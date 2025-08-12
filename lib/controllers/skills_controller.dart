// lib/controllers/skills_controller.dart
import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../services/firebase/firestore_service.dart';
import '../services/firebase/storage_service.dart';
import 'base_controller.dart';
import 'auth_controller.dart';
import 'dart:io';
import 'dart:typed_data';

class SkillsController extends BaseController {
  List<SkillModel> _skills = [];
  List<SkillModel> _filteredSkills = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedProficiencyLevel = 'All';
  
  // Getters
  List<SkillModel> get skills => _filteredSkills;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedProficiencyLevel => _selectedProficiencyLevel;
  
  // Categories
  final List<String> categories = [
    'All',
    'Technical',
    'Leadership',
    'Communication',
    'Project Management',
    'Financial',
    'Analytical',
    'Creative',
    'Languages',
    'Other'
  ];
  
  // Proficiency levels
  final List<String> proficiencyLevels = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];

  // Load user skills
  Future<void> loadUserSkills() async {
    await executeWithLoading(() async {
      final currentUser = AuthController.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }
      
      _skills = await FirestoreService.getUserSkills(currentUser.uid);
      _applyFilters();
    });
  }

  // Load all skills (for admin)
  Future<void> loadAllSkills() async {
    await executeWithLoading(() async {
      _skills = await FirestoreService.getAllSkills();
      _applyFilters();
    });
  }

  // Add new skill
  Future<bool> addSkill({
    required String name,
    required String description,
    required String category,
    required String proficiencyLevel,
    required String experienceYears,
    bool isVerified = false,
    File? certificateFile,
    Uint8List? certificateBytes,
    String? certificateFileName,
  }) async {
    final result = await executeWithLoading(() async {
      final currentUser = AuthController.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      String? certificateURL;
      
      // Upload certificate if provided
      if (certificateFile != null) {
        if (!StorageService.isValidDocumentType(certificateFile.path)) {
          throw Exception('Invalid file type. Please upload PDF, DOC, DOCX, TXT, or image files.');
        }
        
        final fileSize = await certificateFile.length();
        if (!StorageService.isFileSizeValid(fileSize, maxSizeMB: 10)) {
          throw Exception('File size too large. Please upload files smaller than 10MB.');
        }
        
        certificateURL = await StorageService.uploadSkillDocument(
          currentUser.uid,
          'temp_${DateTime.now().millisecondsSinceEpoch}',
          certificateFile,
        );
      } else if (certificateBytes != null && certificateFileName != null) {
        if (!StorageService.isValidDocumentType(certificateFileName)) {
          throw Exception('Invalid file type. Please upload PDF, DOC, DOCX, TXT, or image files.');
        }
        
        if (!StorageService.isFileSizeValid(certificateBytes.length, maxSizeMB: 10)) {
          throw Exception('File size too large. Please upload files smaller than 10MB.');
        }
        
        certificateURL = await StorageService.uploadSkillDocumentFromBytes(
          currentUser.uid,
          'temp_${DateTime.now().millisecondsSinceEpoch}',
          certificateBytes,
          certificateFileName,
        );
      }

      final skill = SkillModel(
        id: '',
        userId: currentUser.uid,
        name: name.trim(),
        description: description.trim(),
        category: category,
        proficiencyLevel: proficiencyLevel,
        experienceYears: experienceYears,
        isVerified: isVerified,
        certificateURL: certificateURL,
        createdAt: DateTime.now(),
      );

      final skillId = await FirestoreService.addSkill(skill);
      
      // Update the skill with the actual ID for storage purposes
      final updatedSkill = skill.copyWith(id: skillId);
      _skills.insert(0, updatedSkill);
      _applyFilters();
      
      return true;
    });
    
    return result ?? false;
  }

  // Update skill
  Future<bool> updateSkill({
    required String skillId,
    required String name,
    required String description,
    required String category,
    required String proficiencyLevel,
    required String experienceYears,
    File? newCertificateFile,
    Uint8List? newCertificateBytes,
    String? newCertificateFileName,
    bool removeCertificate = false,
  }) async {
    final result = await executeWithLoading(() async {
      final currentUser = AuthController.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final skillIndex = _skills.indexWhere((skill) => skill.id == skillId);
      if (skillIndex == -1) {
        throw Exception('Skill not found');
      }

      final currentSkill = _skills[skillIndex];
      String? certificateURL = currentSkill.certificateURL;
      
      // Handle certificate changes
      if (removeCertificate && certificateURL != null) {
        await StorageService.deleteSkillDocument(certificateURL);
        certificateURL = null;
      } else if (newCertificateFile != null) {
        // Delete old certificate if exists
        if (certificateURL != null) {
          await StorageService.deleteSkillDocument(certificateURL);
        }
        
        if (!StorageService.isValidDocumentType(newCertificateFile.path)) {
          throw Exception('Invalid file type. Please upload PDF, DOC, DOCX, TXT, or image files.');
        }
        
        final fileSize = await newCertificateFile.length();
        if (!StorageService.isFileSizeValid(fileSize, maxSizeMB: 10)) {
          throw Exception('File size too large. Please upload files smaller than 10MB.');
        }
        
        certificateURL = await StorageService.uploadSkillDocument(
          currentUser.uid,
          skillId,
          newCertificateFile,
        );
      } else if (newCertificateBytes != null && newCertificateFileName != null) {
        // Delete old certificate if exists
        if (certificateURL != null) {
          await StorageService.deleteSkillDocument(certificateURL);
        }
        
        if (!StorageService.isValidDocumentType(newCertificateFileName)) {
          throw Exception('Invalid file type. Please upload PDF, DOC, DOCX, TXT, or image files.');
        }
        
        if (!StorageService.isFileSizeValid(newCertificateBytes.length, maxSizeMB: 10)) {
          throw Exception('File size too large. Please upload files smaller than 10MB.');
        }
        
        certificateURL = await StorageService.uploadSkillDocumentFromBytes(
          currentUser.uid,
          skillId,
          newCertificateBytes,
          newCertificateFileName,
        );
      }

      final updatedSkill = currentSkill.copyWith(
        name: name.trim(),
        description: description.trim(),
        category: category,
        proficiencyLevel: proficiencyLevel,
        experienceYears: experienceYears,
        certificateURL: certificateURL,
        updatedAt: DateTime.now(),
      );

      await FirestoreService.updateSkill(updatedSkill);
      _skills[skillIndex] = updatedSkill;
      _applyFilters();
      
      return true;
    });
    
    return result ?? false;
  }

  // Delete skill
  Future<bool> deleteSkill(String skillId) async {
    final result = await executeWithLoading(() async {
      final skillIndex = _skills.indexWhere((skill) => skill.id == skillId);
      if (skillIndex == -1) {
        throw Exception('Skill not found');
      }

      final skill = _skills[skillIndex];
      
      // Delete certificate if exists
      if (skill.certificateURL != null) {
        await StorageService.deleteSkillDocument(skill.certificateURL!);
      }
      
      await FirestoreService.deleteSkill(skillId);
      _skills.removeAt(skillIndex);
      _applyFilters();
      
      return true;
    });
    
    return result ?? false;
  }

  // Verify/Unverify skill (Admin only)
  Future<bool> toggleSkillVerification(String skillId, bool isVerified) async {
    final result = await executeWithLoading(() async {
      final isAdmin = await AuthController.isAdmin();
      if (!isAdmin) {
        throw Exception('Only administrators can verify skills');
      }

      final skillIndex = _skills.indexWhere((skill) => skill.id == skillId);
      if (skillIndex == -1) {
        throw Exception('Skill not found');
      }

      final updatedSkill = _skills[skillIndex].copyWith(
        isVerified: isVerified,
        updatedAt: DateTime.now(),
      );

      await FirestoreService.updateSkill(updatedSkill);
      _skills[skillIndex] = updatedSkill;
      _applyFilters();
      
      return true;
    });
    
    return result ?? false;
  }

  // Search skills
  void searchSkills(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Filter by proficiency level
  void filterByProficiencyLevel(String level) {
    _selectedProficiencyLevel = level;
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedProficiencyLevel = 'All';
    _applyFilters();
  }

  // Apply filters
  void _applyFilters() {
    _filteredSkills = _skills.where((skill) {
      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          skill.name.toLowerCase().contains(_searchQuery) ||
          skill.description.toLowerCase().contains(_searchQuery) ||
          skill.category.toLowerCase().contains(_searchQuery);

      // Category filter
      final matchesCategory = _selectedCategory == 'All' || 
          skill.category == _selectedCategory;

      // Proficiency level filter
      final matchesProficiency = _selectedProficiencyLevel == 'All' || 
          skill.proficiencyLevel == _selectedProficiencyLevel;

      return matchesSearch && matchesCategory && matchesProficiency;
    }).toList();

    // Sort by creation date (newest first)
    _filteredSkills.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    safeNotifyListeners();
  }

  // Get skills by category
  List<SkillModel> getSkillsByCategory(String category) {
    return _skills.where((skill) => skill.category == category).toList();
  }

  // Get verified skills
  List<SkillModel> getVerifiedSkills() {
    return _skills.where((skill) => skill.isVerified).toList();
  }

  // Get unverified skills
  List<SkillModel> getUnverifiedSkills() {
    return _skills.where((skill) => !skill.isVerified).toList();
  }

  // Get skills statistics
  Map<String, int> getSkillsStatistics() {
    final stats = <String, int>{};
    
    stats['total'] = _skills.length;
    stats['verified'] = _skills.where((skill) => skill.isVerified).length;
    stats['unverified'] = _skills.where((skill) => !skill.isVerified).length;
    stats['withCertificates'] = _skills.where((skill) => skill.certificateURL != null).length;
    
    // Count by category
    for (final category in categories.where((c) => c != 'All')) {
      stats['category_$category'] = _skills.where((skill) => skill.category == category).length;
    }
    
    // Count by proficiency level
    for (final level in proficiencyLevels.where((l) => l != 'All')) {
      stats['proficiency_$level'] = _skills.where((skill) => skill.proficiencyLevel == level).length;
    }
    
    return stats;
  }

  // Get category distribution for charts
  Map<String, int> getCategoryDistribution() {
    final distribution = <String, int>{};
    
    for (final skill in _skills) {
      distribution[skill.category] = (distribution[skill.category] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Get proficiency distribution for charts
  Map<String, int> getProficiencyDistribution() {
    final distribution = <String, int>{};
    
    for (final skill in _skills) {
      distribution[skill.proficiencyLevel] = (distribution[skill.proficiencyLevel] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Export skills data (for admin)
  Future<List<Map<String, dynamic>>> exportSkillsData() async {
    final isAdmin = await AuthController.isAdmin();
    if (!isAdmin) {
      throw Exception('Only administrators can export skills data');
    }

    return _skills.map((skill) => {
      'ID': skill.id,
      'User ID': skill.userId,
      'Name': skill.name,
      'Description': skill.description,
      'Category': skill.category,
      'Proficiency Level': skill.proficiencyLevel,
      'Experience Years': skill.experienceYears,
      'Is Verified': skill.isVerified ? 'Yes' : 'No',
      'Has Certificate': skill.certificateURL != null ? 'Yes' : 'No',
      'Created At': skill.createdAt.toIso8601String(),
      'Updated At': skill.updatedAt?.toIso8601String() ?? '',
    }).toList();
  }

  // Validate skill data
  static String? validateSkillName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Skill name is required';
    }
    if (name.trim().length < 2) {
      return 'Skill name must be at least 2 characters';
    }
    if (name.trim().length > 50) {
      return 'Skill name must be less than 50 characters';
    }
    return null;
  }

  static String? validateSkillDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return 'Description is required';
    }
    if (description.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (description.trim().length > 500) {
      return 'Description must be less than 500 characters';
    }
    return null;
  }

  static String? validateExperienceYears(String? years) {
    if (years == null || years.trim().isEmpty) {
      return 'Experience years is required';
    }
    
    final yearsInt = int.tryParse(years.trim());
    if (yearsInt == null) {
      return 'Please enter a valid number';
    }
    
    if (yearsInt < 0) {
      return 'Experience years cannot be negative';
    }
    
    if (yearsInt > 50) {
      return 'Experience years seems too high';
    }
    
    return null;
  }

  @override
  void dispose() {
    _skills.clear();
    _filteredSkills.clear();
    super.dispose();
  }
}