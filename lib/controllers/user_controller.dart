// lib/controllers/user_controller.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase/firestore_service.dart';
import '../services/firebase/storage_service.dart';
import 'base_controller.dart';
import 'auth_controller.dart';
import 'dart:io';
import 'dart:typed_data';

class UserController extends BaseController {
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  UserModel? _currentUserData;
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  String _selectedUserType = 'All';

  // Getters
  List<UserModel> get users => _filteredUsers;
  UserModel? get currentUserData => _currentUserData;
  String get searchQuery => _searchQuery;
  String get selectedDepartment => _selectedDepartment;
  String get selectedUserType => _selectedUserType;

  // User types
  final List<String> userTypes = ['All', 'Employee', 'Admin'];

  // Load current user data
  Future<void> loadCurrentUserData() async {
    await executeWithLoading(() async {
      _currentUserData = await AuthController.getCurrentUserData();
      if (_currentUserData == null) {
        throw Exception('Failed to load user data');
      }
    });
  }

  // Load all users (Admin only)
  Future<void> loadAllUsers() async {
    await executeWithLoading(() async {
      final isAdmin = await AuthController.isAdmin();
      if (!isAdmin) {
        throw Exception('Only administrators can view all users');
      }
      
      _users = await FirestoreService.getAllUsers();
      _applyFilters();
    });
  }

  // Load users by department
  Future<void> loadUsersByDepartment(String department) async {
    await executeWithLoading(() async {
      _users = await FirestoreService.getUsersByDepartment(department);
      _applyFilters();
    });
  }

  // Update user profile
  Future<bool> updateProfile({
    required String name,
    required String department,
    File? profileImageFile,
    Uint8List? profileImageBytes,
    String? profileImageFileName,
    bool removeProfileImage = false,
  }) async {
    final result = await executeWithLoading(() async {
      final currentUser = AuthController.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      if (_currentUserData == null) {
        throw Exception('Current user data not loaded');
      }

      String? profileImageURL = _currentUserData!.profileImageURL;

      // Handle profile image changes
      if (removeProfileImage && profileImageURL != null) {
        await StorageService.deleteProfileImage(profileImageURL);
        profileImageURL = null;
      } else if (profileImageFile != null) {
        // Delete old image if exists
        if (profileImageURL != null) {
          await StorageService.deleteProfileImage(profileImageURL);
        }

        if (!StorageService.isValidImageType(profileImageFile.path)) {
          throw Exception('Invalid image type. Please upload JPG, PNG, GIF, or WebP files.');
        }

        final fileSize = await profileImageFile.length();
        if (!StorageService.isFileSizeValid(fileSize, maxSizeMB: 5)) {
          throw Exception('Image size too large. Please upload images smaller than 5MB.');
        }

        profileImageURL = await StorageService.uploadProfileImage(
          currentUser.uid,
          profileImageFile,
        );
      } else if (profileImageBytes != null && profileImageFileName != null) {
        // Delete old image if exists
        if (profileImageURL != null) {
          await StorageService.deleteProfileImage(profileImageURL);
        }

        if (!StorageService.isValidImageType(profileImageFileName)) {
          throw Exception('Invalid image type. Please upload JPG, PNG, GIF, or WebP files.');
        }

        if (!StorageService.isFileSizeValid(profileImageBytes.length, maxSizeMB: 5)) {
          throw Exception('Image size too large. Please upload images smaller than 5MB.');
        }

        profileImageURL = await StorageService.uploadProfileImageFromBytes(
          currentUser.uid,
          profileImageBytes,
          profileImageFileName,
        );
      }

      final updatedUser = _currentUserData!.copyWith(
        name: name.trim(),
        department: department.trim(),
        profileImageURL: profileImageURL,
        updatedAt: DateTime.now(),
      );

      await FirestoreService.updateUser(updatedUser);
      _currentUserData = updatedUser;

      // Update user in the list if it exists
      final userIndex = _users.indexWhere((user) => user.id == currentUser.uid);
      if (userIndex != -1) {
        _users[userIndex] = updatedUser;
        _applyFilters();
      }

      return true;
    });

    return result ?? false;
  }

  // Update user type (Admin only)
  Future<bool> updateUserType(String userId, String newUserType) async {
    final result = await executeWithLoading(() async {
      final isAdmin = await AuthController.isAdmin();
      if (!isAdmin) {
        throw Exception('Only administrators can change user types');
      }

      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex == -1) {
        throw Exception('User not found');
      }

      final updatedUser = _users[userIndex].copyWith(
        userType: newUserType,
        updatedAt: DateTime.now(),
      );

      await FirestoreService.updateUser(updatedUser);
      _users[userIndex] = updatedUser;
      _applyFilters();

      return true;
    });

    return result ?? false;
  }

  // Delete user (Admin only)
  Future<bool> deleteUser(String userId) async {
    final result = await executeWithLoading(() async {
      final isAdmin = await AuthController.isAdmin();
      if (!isAdmin) {
        throw Exception('Only administrators can delete users');
      }

      final currentUser = AuthController.currentUser;
      if (currentUser?.uid == userId) {
        throw Exception('Cannot delete your own account from here');
      }

      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex == -1) {
        throw Exception('User not found');
      }

      final user = _users[userIndex];

      // Delete user's profile image if exists
      if (user.profileImageURL != null) {
        await StorageService.deleteProfileImage(user.profileImageURL!);
      }

      // Delete all user files
      await StorageService.deleteAllUserFiles(userId);

      // Delete user from Firestore (this will also delete their skills)
      await FirestoreService.deleteUser(userId);

      _users.removeAt(userIndex);
      _applyFilters();

      return true;
    });

    return result ?? false;
  }

  // Search users
  void searchUsers(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // Filter by department
  void filterByDepartment(String department) {
    _selectedDepartment = department;
    _applyFilters();
  }

  // Filter by user type
  void filterByUserType(String userType) {
    _selectedUserType = userType;
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedDepartment = 'All';
    _selectedUserType = 'All';
    _applyFilters();
  }

  // Apply filters
  void _applyFilters() {
    _filteredUsers = _users.where((user) {
      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery) ||
          user.department.toLowerCase().contains(_searchQuery);

      // Department filter
      final matchesDepartment = _selectedDepartment == 'All' || 
          user.department == _selectedDepartment;

      // User type filter
      final matchesUserType = _selectedUserType == 'All' || 
          user.userType == _selectedUserType;

      return matchesSearch && matchesDepartment && matchesUserType;
    }).toList();

    // Sort by name
    _filteredUsers.sort((a, b) => a.name.compareTo(b.name));
    safeNotifyListeners();
  }

  // Get all departments
  Future<List<String>> getAllDepartments() async {
    return await executeWithErrorHandling(() async {
      return await FirestoreService.getAllDepartments();
    }) ?? [];
  }

  // Get users by department
  List<UserModel> getUsersByDepartment(String department) {
    return _users.where((user) => user.department == department).toList();
  }

  // Get admin users
  List<UserModel> getAdminUsers() {
    return _users.where((user) => user.userType == 'Admin').toList();
  }

  // Get employee users
  List<UserModel> getEmployeeUsers() {
    return _users.where((user) => user.userType == 'Employee').toList();
  }

  // Get users statistics
  Map<String, int> getUsersStatistics() {
    final stats = <String, int>{};
    
    stats['total'] = _users.length;
    stats['employees'] = _users.where((user) => user.userType == 'Employee').length;
    stats['admins'] = _users.where((user) => user.userType == 'Admin').length;
    stats['withProfileImages'] = _users.where((user) => user.profileImageURL != null).length;
    
    // Count by department
    final departments = <String>{};
    for (final user in _users) {
      departments.add(user.department);
    }
    
    for (final department in departments) {
      stats['department_$department'] = _users.where((user) => user.department == department).length;
    }
    
    return stats;
  }

  // Get department distribution for charts
  Map<String, int> getDepartmentDistribution() {
    final distribution = <String, int>{};
    
    for (final user in _users) {
      distribution[user.department] = (distribution[user.department] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Get user type distribution for charts
  Map<String, int> getUserTypeDistribution() {
    final distribution = <String, int>{};
    
    for (final user in _users) {
      distribution[user.userType] = (distribution[user.userType] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Export users data (Admin only)
  Future<List<Map<String, dynamic>>> exportUsersData() async {
    final isAdmin = await AuthController.isAdmin();
    if (!isAdmin) {
      throw Exception('Only administrators can export user data');
    }

    return _users.map((user) => {
      'ID': user.id,
      'Name': user.name,
      'Email': user.email,
      'Department': user.department,
      'User Type': user.userType,
      'Skills Count': user.skills.length,
      'Has Profile Image': user.profileImageURL != null ? 'Yes' : 'No',
      'Created At': user.createdAt.toIso8601String(),
      'Updated At': user.updatedAt?.toIso8601String() ?? '',
    }).toList();
  }

  // Check if user exists
  Future<bool> userExists(String userId) async {
    return await executeWithErrorHandling(() async {
      return await FirestoreService.userExists(userId);
    }) ?? false;
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    return await executeWithErrorHandling(() async {
      return await FirestoreService.getUser(userId);
    });
  }

  // Refresh current user data
  Future<void> refreshCurrentUserData() async {
    await executeWithErrorHandling(() async {
      final currentUser = AuthController.currentUser;
      if (currentUser != null) {
        _currentUserData = await FirestoreService.getUser(currentUser.uid);
        safeNotifyListeners();
      }
    });
  }

  // Validate profile data
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (name.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s-\'\.]+).hasMatch(name.trim())) {
      return 'Name can only contain letters, spaces, hyphens, apostrophes, and periods';
    }
    return null;
  }

  static String? validateDepartment(String? department) {
    if (department == null || department.trim().isEmpty) {
      return 'Department is required';
    }
    if (department.trim().length < 2) {
      return 'Department must be at least 2 characters';
    }
    if (department.trim().length > 50) {
      return 'Department must be less than 50 characters';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}).hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Get recently joined users (last 30 days)
  List<UserModel> getRecentlyJoinedUsers() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return _users.where((user) => user.createdAt.isAfter(thirtyDaysAgo)).toList();
  }

  // Get users without profile images
  List<UserModel> getUsersWithoutProfileImage() {
    return _users.where((user) => user.profileImageURL == null).toList();
  }

  // Get users with most skills
  List<UserModel> getUsersWithMostSkills({int limit = 10}) {
    final sortedUsers = List<UserModel>.from(_users);
    sortedUsers.sort((a, b) => b.skills.length.compareTo(a.skills.length));
    return sortedUsers.take(limit).toList();
  }

  @override
  void dispose() {
    _users.clear();
    _filteredUsers.clear();
    _currentUserData = null;
    super.dispose();
  }
}