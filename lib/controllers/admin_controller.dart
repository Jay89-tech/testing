// lib/controllers/admin_controller.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/skill_model.dart';
import '../services/firebase/firestore_service.dart';
import 'base_controller.dart';
import 'auth_controller.dart';
import 'user_controller.dart';
import 'skills_controller.dart';

class AdminController extends BaseController {
  // Dashboard statistics
  Map<String, int> _dashboardStats = {};
  Map<String, int> _departmentStats = {};
  Map<String, int> _skillsCategoryStats = {};
  Map<String, int> _userTypeStats = {};
  
  // Recent activities
  List<UserModel> _recentUsers = [];
  List<SkillModel> _recentSkills = [];
  List<SkillModel> _pendingVerifications = [];

  // Controllers
  final UserController _userController = UserController();
  final SkillsController _skillsController = SkillsController();

  // Getters
  Map<String, int> get dashboardStats => _dashboardStats;
  Map<String, int> get departmentStats => _departmentStats;
  Map<String, int> get skillsCategoryStats => _skillsCategoryStats;
  Map<String, int> get userTypeStats => _userTypeStats;
  
  List<UserModel> get recentUsers => _recentUsers;
  List<SkillModel> get recentSkills => _recentSkills;
  List<SkillModel> get pendingVerifications => _pendingVerifications;
  
  UserController get userController => _userController;
  SkillsController get skillsController => _skillsController;

  // Initialize admin dashboard
  Future<void> initializeAdminDashboard() async {
    await executeWithLoading(() async {
      final isAdmin = await AuthController.isAdmin();
      if (!isAdmin) {
        throw Exception('Admin access required');
      }

      // Load all data concurrently
      await Future.wait([
        _loadDashboardStatistics(),
        _loadRecentActivities(),
        _userController.loadAllUsers(),
        _skillsController.loadAllSkills(),
      ]);
    });
  }

  // Load dashboard statistics
  Future<void> _loadDashboardStatistics() async {
    try {
      // Get basic counts
      final totalUsers = await FirestoreService.getTotalUsersCount();
      final totalSkills = await FirestoreService.getTotalSkillsCount();
      
      // Get detailed statistics
      final departmentDistribution = await FirestoreService.getUsersCountByDepartment();
      final skillsCategoryDistribution = await FirestoreService.getSkillsCountByCategory();
      
      // Calculate derived statistics
      final allUsers = await FirestoreService.getAllUsers();
      final allSkills = await FirestoreService.getAllSkills();
      
      final adminCount = allUsers.where((user) => user.userType == 'Admin').length;
      final employeeCount = allUsers.where((user) => user.userType == 'Employee').length;
      final verifiedSkillsCount = allSkills.where((skill) => skill.isVerified).length;
      final unverifiedSkillsCount = allSkills.where((skill) => !skill.isVerified).length;
      final skillsWithCertificates = allSkills.where((skill) => skill.certificateURL != null).length;
      
      // Recent statistics (last 30 days)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final recentUsersCount = allUsers.where((user) => user.createdAt.isAfter(thirtyDaysAgo)).length;
      final recentSkillsCount = allSkills.where((skill) => skill.createdAt.isAfter(thirtyDaysAgo)).length;

      _dashboardStats = {
        'totalUsers': totalUsers,
        'totalSkills': totalSkills,
        'adminUsers': adminCount,
        'employeeUsers': employeeCount,
        'verifiedSkills': verifiedSkillsCount,
        'unverifiedSkills': unverifiedSkillsCount,
        'skillsWithCertificates': skillsWithCertificates,
        'recentUsers': recentUsersCount,
        'recentSkills': recentSkillsCount,
        'totalDepartments': departmentDistribution.length,
        'totalCategories': skillsCategoryDistribution.length,
      };

      _departmentStats = departmentDistribution;
      _skillsCategoryStats = skillsCategoryDistribution;
      _userTypeStats = {
        'Admin': adminCount,
        'Employee': employeeCount,
      };

    } catch (e) {
      throw Exception('Failed to load dashboard statistics: $e');
    }
  }

  // Load recent activities
  Future<void> _loadRecentActivities() async {
    try {
      final allUsers = await FirestoreService.getAllUsers();
      final allSkills = await FirestoreService.getAllSkills();

      // Get recent users (last 30 days, max 10)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      _recentUsers = allUsers
          .where((user) => user.createdAt.isAfter(thirtyDaysAgo))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      if (_recentUsers.length > 10) {
        _recentUsers = _recentUsers.sublist(0, 10);
      }

      // Get recent skills (last 30 days, max 10)
      _recentSkills = allSkills
          .where((skill) => skill.createdAt.isAfter(thirtyDaysAgo))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      if (_recentSkills.length > 10) {
        _recentSkills = _recentSkills.sublist(0, 10);
      }

      // Get pending verifications (unverified skills, max 20)
      _pendingVerifications = allSkills
          .where((skill) => !skill.isVerified)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      
      if (_pendingVerifications.length > 20) {
        _pendingVerifications = _pendingVerifications.sublist(0, 20);
      }

    } catch (e) {
      throw Exception('Failed to load recent activities: $e');
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await executeWithLoading(() async {
      await _loadDashboardStatistics();
      await _loadRecentActivities();
    });
  }

  // Verify skill
  Future<bool> verifySkill(String skillId) async {
    final result = await executeWithErrorHandling(() async {
      await _skillsController.toggleSkillVerification(skillId, true);
      
      // Remove from pending verifications
      _pendingVerifications.removeWhere((skill) => skill.id == skillId);
      
      // Update statistics
      _dashboardStats['verifiedSkills'] = (_dashboardStats['verifiedSkills'] ?? 0) + 1;
      _dashboardStats['unverifiedSkills'] = (_dashboardStats['unverifiedSkills'] ?? 0) - 1;
      
      safeNotifyListeners();
      return true;
    });
    
    return result ?? false;
  }

  // Reject skill verification
  Future<bool> rejectSkillVerification(String skillId) async {
    final result = await executeWithErrorHandling(() async {
      // For now, we'll just remove it from pending list
      // In a full implementation, you might want to add a "rejected" status
      _pendingVerifications.removeWhere((skill) => skill.id == skillId);
      
      safeNotifyListeners();
      return true;
    });
    
    return result ?? false;
  }

  // Delete skill (admin action)
  Future<bool> deleteSkillAsAdmin(String skillId) async {
    final result = await executeWithErrorHandling(() async {
      await _skillsController.deleteSkill(skillId);
      
      // Remove from pending verifications if it was there
      _pendingVerifications.removeWhere((skill) => skill.id == skillId);
      
      // Remove from recent skills if it was there
      _recentSkills.removeWhere((skill) => skill.id == skillId);
      
      // Update statistics
      _dashboardStats['totalSkills'] = (_dashboardStats['totalSkills'] ?? 0) - 1;
      
      safeNotifyListeners();
      return true;
    });
    
    return result ?? false;
  }

  // Update user type
  Future<bool> updateUserType(String userId, String newUserType) async {
    final result = await executeWithErrorHandling(() async {
      await _userController.updateUserType(userId, newUserType);
      
      // Update statistics
      if (newUserType == 'Admin') {
        _dashboardStats['adminUsers'] = (_dashboardStats['adminUsers'] ?? 0) + 1;
        _dashboardStats['employeeUsers'] = (_dashboardStats['employeeUsers'] ?? 0) - 1;
        _userTypeStats['Admin'] = (_userTypeStats['Admin'] ?? 0) + 1;
        _userTypeStats['Employee'] = (_userTypeStats['Employee'] ?? 0) - 1;
      } else {
        _dashboardStats['adminUsers'] = (_dashboardStats['adminUsers'] ?? 0) - 1;
        _dashboardStats['employeeUsers'] = (_dashboardStats['employeeUsers'] ?? 0) + 1;
        _userTypeStats['Admin'] = (_userTypeStats['Admin'] ?? 0) - 1;
        _userTypeStats['Employee'] = (_userTypeStats['Employee'] ?? 0) + 1;
      }
      
      safeNotifyListeners();
      return true;
    });
    
    return result ?? false;
  }

  // Delete user as admin
  Future<bool> deleteUserAsAdmin(String userId) async {
    final result = await executeWithErrorHandling(() async {
      await _userController.deleteUser(userId);
      
      // Remove from recent users if it was there
      _recentUsers.removeWhere((user) => user.id == userId);
      
      // Update statistics
      _dashboardStats['totalUsers'] = (_dashboardStats['totalUsers'] ?? 0) - 1;
      
      safeNotifyListeners();
      return true;
    });
    
    return result ?? false;
  }

  // Get system health metrics
  Map<String, dynamic> getSystemHealthMetrics() {
    final totalUsers = _dashboardStats['totalUsers'] ?? 0;
    final totalSkills = _dashboardStats['totalSkills'] ?? 0;
    final verifiedSkills = _dashboardStats['verifiedSkills'] ?? 0;
    final unverifiedSkills = _dashboardStats['unverifiedSkills'] ?? 0;
    final skillsWithCertificates = _dashboardStats['skillsWithCertificates'] ?? 0;
    
    final verificationRate = totalSkills > 0 ? (verifiedSkills / totalSkills * 100) : 0;
    final certificateRate = totalSkills > 0 ? (skillsWithCertificates / totalSkills * 100) : 0;
    final averageSkillsPerUser = totalUsers > 0 ? (totalSkills / totalUsers) : 0;
    
    return {
      'verificationRate': verificationRate.toStringAsFixed(1),
      'certificateRate': certificateRate.toStringAsFixed(1),
      'averageSkillsPerUser': averageSkillsPerUser.toStringAsFixed(1),
      'pendingVerifications': _pendingVerifications.length,
      'activeDepartments': _departmentStats.length,
      'activeCategories': _skillsCategoryStats.length,
    };
  }

  // Get department performance
  List<Map<String, dynamic>> getDepartmentPerformance() {
    final performanceList = <Map<String, dynamic>>[];
    
    for (final entry in _departmentStats.entries) {
      final department = entry.key;
      final userCount = entry.value;
      
      // Get skills count for this department
      final departmentSkillsCount = _recentSkills
          .where((skill) => _userController.users
              .firstWhere((user) => user.id == skill.userId, 
                  orElse: () => UserModel(
                      id: '', 
                      name: '', 
                      email: '', 
                      department: '', 
                      userType: '', 
                      skills: [], 
                      createdAt: DateTime.now()))
              .department == department)
          .length;
      
      final averageSkillsPerUser = userCount > 0 ? (departmentSkillsCount / userCount) : 0;
      
      performanceList.add({
        'department': department,
        'userCount': userCount,
        'skillsCount': departmentSkillsCount,
        'averageSkillsPerUser': averageSkillsPerUser.toStringAsFixed(1),
      });
    }
    
    // Sort by user count descending
    performanceList.sort((a, b) => (b['userCount'] as int).compareTo(a['userCount'] as int));
    
    return performanceList;
  }

  // Get trending skills
  List<Map<String, dynamic>> getTrendingSkills({int limit = 10}) {
    final skillFrequency = <String, int>{};
    
    // Count skill names frequency
    for (final skill in _recentSkills) {
      skillFrequency[skill.name] = (skillFrequency[skill.name] ?? 0) + 1;
    }
    
    // Convert to list and sort
    final trendingList = skillFrequency.entries.map((entry) => {
      'skillName': entry.key,
      'frequency': entry.value,
    }).toList();
    
    trendingList.sort((a, b) => (b['frequency'] as int).compareTo(a['frequency'] as int));
    
    return trendingList.take(limit).toList();
  }

  // Export comprehensive report
  Future<Map<String, List<Map<String, dynamic>>>> exportComprehensiveReport() async {
    final isAdmin = await AuthController.isAdmin();
    if (!isAdmin) {
      throw Exception('Admin access required');
    }

    return {
      'users': await _userController.exportUsersData(),
      'skills': await _skillsController.exportSkillsData(),
      'statistics': [
        {
          'metric': 'Total Users',
          'value': _dashboardStats['totalUsers'],
        },
        {
          'metric': 'Total Skills',
          'value': _dashboardStats['totalSkills'],
        },
        {
          'metric': 'Verified Skills',
          'value': _dashboardStats['verifiedSkills'],
        },
        {
          'metric': 'Skills with Certificates',
          'value': _dashboardStats['skillsWithCertificates'],
        },
      ],
      'departmentStats': _departmentStats.entries.map((entry) => {
        'department': entry.key,
        'userCount': entry.value,
      }).toList(),
      'skillsCategoryStats': _skillsCategoryStats.entries.map((entry) => {
        'category': entry.key,
        'skillCount': entry.value,
      }).toList(),
    };
  }

  // Search across all entities
  Future<Map<String, List<dynamic>>> searchAll(String query) async {
    return await executeWithErrorHandling(() async {
      if (query.trim().isEmpty) {
        return <String, List<dynamic>>{
          'users': <UserModel>[],
          'skills': <SkillModel>[],
        };
      }

      final searchResults = <String, List<dynamic>>{};
      
      // Search users
      _userController.searchUsers(query);
      searchResults['users'] = _userController.users;
      
      // Search skills
      _skillsController.searchSkills(query);
      searchResults['skills'] = _skillsController.skills;
      
      return searchResults;
    }) ?? <String, List<dynamic>>{
      'users': <UserModel>[],
      'skills': <SkillModel>[],
    };
  }

  // Get audit trail (mock implementation)
  List<Map<String, dynamic>> getAuditTrail({int limit = 50}) {
    final auditTrail = <Map<String, dynamic>>[];
    
    // Add recent user activities
    for (final user in _recentUsers) {
      auditTrail.add({
        'type': 'USER_CREATED',
        'description': 'New user registered: ${user.name}',
        'user': user.name,
        'timestamp': user.createdAt,
        'details': 'Department: ${user.department}, Type: ${user.userType}',
      });
    }
    
    // Add recent skill activities
    for (final skill in _recentSkills) {
      final user = _userController.users.firstWhere(
        (u) => u.id == skill.userId,
        orElse: () => UserModel(
            id: '', 
            name: 'Unknown User', 
            email: '', 
            department: '', 
            userType: '', 
            skills: [], 
            createdAt: DateTime.now()),
      );
      
      auditTrail.add({
        'type': 'SKILL_ADDED',
        'description': 'New skill added: ${skill.name}',
        'user': user.name,
        'timestamp': skill.createdAt,
        'details': 'Category: ${skill.category}, Level: ${skill.proficiencyLevel}',
      });
    }
    
    // Sort by timestamp descending
    auditTrail.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
    
    return auditTrail.take(limit).toList();
  }

  @override
  void dispose() {
    _userController.dispose();
    _skillsController.dispose();
    _dashboardStats.clear();
    _departmentStats.clear();
    _skillsCategoryStats.clear();
    _userTypeStats.clear();
    _recentUsers.clear();
    _recentSkills.clear();
    _pendingVerifications.clear();
    super.dispose();
  }
}