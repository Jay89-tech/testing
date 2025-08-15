// lib/services/analytics_service.dart
import '../models/user_model.dart';
import '../models/skill_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get analytics data for a specific time period
  static Future<Map<String, dynamic>> getAnalyticsData({
    required String period, // 'weekly', 'monthly', 'quarterly', 'yearly'
  }) async {
    final endDate = DateTime.now();
    late DateTime startDate;

    switch (period.toLowerCase()) {
      case 'weekly':
        startDate = endDate.subtract(const Duration(days: 7));
        break;
      case 'monthly':
        startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
        break;
      case 'quarterly':
        startDate = DateTime(endDate.year, endDate.month - 3, endDate.day);
        break;
      case 'yearly':
        startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);
        break;
      default:
        startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
    }

    try {
      final futures = await Future.wait([
        _getUsersInPeriod(startDate, endDate),
        _getSkillsInPeriod(startDate, endDate),
        _getAllUsers(),
        _getAllSkills(),
      ]);

      final newUsers = futures[0] as List<UserModel>;
      final newSkills = futures[1] as List<SkillModel>;
      final allUsers = futures[2] as List<UserModel>;
      final allSkills = futures[3] as List<SkillModel>;

      return {
        'period': period,
        'startDate': startDate,
        'endDate': endDate,
        'newUsers': newUsers,
        'newSkills': newSkills,
        'allUsers': allUsers,
        'allSkills': allSkills,
        'totalUsers': allUsers.length,
        'totalSkills': allSkills.length,
        'newUsersCount': newUsers.length,
        'newSkillsCount': newSkills.length,
        'skillsByCategory': _groupSkillsByCategory(allSkills),
        'usersByDepartment': _groupUsersByDepartment(allUsers),
        'skillsByProficiency': _groupSkillsByProficiency(allSkills),
        'expiringSkills': _getExpiringSkills(allSkills),
        'topSkills': _getTopSkills(allSkills),
        'mostActiveUsers': _getMostActiveUsers(allUsers, allSkills),
        'departmentStats': _getDepartmentStats(allUsers, allSkills),
        'trends': _calculateTrends(allUsers, allSkills, startDate, endDate),
      };
    } catch (e) {
      throw Exception('Failed to get analytics data: $e');
    }
  }

  // Get users created in a specific period
  static Future<List<UserModel>> _getUsersInPeriod(DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting users in period: $e');
      return [];
    }
  }

  // Get skills created in a specific period
  static Future<List<SkillModel>> _getSkillsInPeriod(DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _firestore
          .collection('skills')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting skills in period: $e');
      return [];
    }
  }

  // Get all users
  static Future<List<UserModel>> _getAllUsers() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  // Get all skills
  static Future<List<SkillModel>> _getAllSkills() async {
    try {
      final snapshot = await _firestore
          .collection('skills')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all skills: $e');
    }
  }

  // Group skills by category
  static Map<String, int> _groupSkillsByCategory(List<SkillModel> skills) {
    final categories = <String, int>{};
    for (final skill in skills) {
      final category = skill.category.isEmpty ? 'Other' : skill.category;
      categories[category] = (categories[category] ?? 0) + 1;
    }
    return Map.fromEntries(
      categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );
  }

  // Group users by department
  static Map<String, int> _groupUsersByDepartment(List<UserModel> users) {
    final departments = <String, int>{};
    for (final user in users) {
      final department = user.department.isEmpty ? 'Other' : user.department;
      departments[department] = (departments[department] ?? 0) + 1;
    }
    return Map.fromEntries(
      departments.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );
  }

  // Group skills by proficiency
  static Map<String, int> _groupSkillsByProficiency(List<SkillModel> skills) {
    final proficiency = <String, int>{};
    for (final skill in skills) {
      final level = skill.proficiencyLevel.isEmpty ? 'Beginner' : skill.proficiencyLevel;
      proficiency[level] = (proficiency[level] ?? 0) + 1;
    }
    return proficiency;
  }

  // Get skills expiring in the next 30 days
  static List<SkillModel> _getExpiringSkills(List<SkillModel> skills) {
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));

    return skills.where((skill) {
      if (skill.expiryDate == null) return false;
      return skill.expiryDate!.isAfter(now) && 
             skill.expiryDate!.isBefore(thirtyDaysFromNow);
    }).toList();
  }

  // Get top 5 most common skills
  static List<Map<String, dynamic>> _getTopSkills(List<SkillModel> skills) {
    final skillCounts = <String, List<String>>{};
    
    for (final skill in skills) {
      if (!skillCounts.containsKey(skill.name)) {
        skillCounts[skill.name] = [];
      }
      skillCounts[skill.name]!.add(skill.userId);
    }

    final sortedSkills = skillCounts.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return sortedSkills.take(5).map((entry) => {
      'name': entry.key,
      'userCount': entry.value.length,
      'userIds': entry.value,
    }).toList();
  }

  // Get most active users (users with most skills)
  static List<Map<String, dynamic>> _getMostActiveUsers(List<UserModel> users, List<SkillModel> skills) {
    final userSkillCounts = <String, int>{};
    
    for (final skill in skills) {
      userSkillCounts[skill.userId] = (userSkillCounts[skill.userId] ?? 0) + 1;
    }

    final activeUsers = users.where((user) => userSkillCounts.containsKey(user.id)).toList()
      ..sort((a, b) => (userSkillCounts[b.id] ?? 0).compareTo(userSkillCounts[a.id] ?? 0));

    return activeUsers.take(5).map((user) => {
      'user': user,
      'skillCount': userSkillCounts[user.id] ?? 0,
    }).toList();
  }

  // Get department statistics
  static Map<String, Map<String, dynamic>> _getDepartmentStats(List<UserModel> users, List<SkillModel> skills) {
    final deptStats = <String, Map<String, dynamic>>{};
    
    final usersByDept = _groupUsersByDepartment(users);
    
    for (final dept in usersByDept.keys) {
      final deptUsers = users.where((u) => u.department == dept).toList();
      final deptSkills = skills.where((s) => 
        deptUsers.any((u) => u.id == s.userId)).toList();
      
      final avgSkillsPerUser = deptUsers.isEmpty ? 0.0 : deptSkills.length / deptUsers.length;
      final certifiedSkills = deptSkills.where((s) => s.isVerified).length;
      
      deptStats[dept] = {
        'userCount': deptUsers.length,
        'skillCount': deptSkills.length,
        'avgSkillsPerUser': avgSkillsPerUser,
        'certifiedSkills': certifiedSkills,
      };
    }
    
    return deptStats;
  }

  // Calculate trends (growth rates)
  static Map<String, double> _calculateTrends(
    List<UserModel> users, 
    List<SkillModel> skills, 
    DateTime startDate, 
    DateTime endDate,
  ) {
    // For demo purposes, calculate approximate growth rates
    final totalUsers = users.length;
    final totalSkills = skills.length;
    
    // Calculate users created in period
    final newUsersInPeriod = users.where((user) => 
      user.createdAt.isAfter(startDate) && user.createdAt.isBefore(endDate)
    ).length;
    
    // Calculate skills created in period
    final newSkillsInPeriod = skills.where((skill) => 
      skill.createdAt.isAfter(startDate) && skill.createdAt.isBefore(endDate)
    ).length;

    // Calculate growth rates (as percentages)
    final userGrowthRate = totalUsers > newUsersInPeriod 
      ? (newUsersInPeriod / (totalUsers - newUsersInPeriod)) * 100
      : 0.0;
    
    final skillGrowthRate = totalSkills > newSkillsInPeriod 
      ? (newSkillsInPeriod / (totalSkills - newSkillsInPeriod)) * 100
      : 0.0;

    return {
      'userGrowthRate': userGrowthRate,
      'skillGrowthRate': skillGrowthRate,
      'newUsers': newUsersInPeriod.toDouble(),
      'newSkills': newSkillsInPeriod.toDouble(),
    };
  }

  // Get skills growth data for charts (last 6 months)
  static Future<List<Map<String, dynamic>>> getSkillsGrowthData() async {
    try {
      final now = DateTime.now();
      final growthData = <Map<String, dynamic>>[];

      for (int i = 5; i >= 0; i--) {
        final monthStart = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 1).subtract(const Duration(days: 1));

        final snapshot = await _firestore
            .collection('skills')
            .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart))
            .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(monthEnd))
            .get();

        growthData.add({
          'month': _getMonthName(monthStart.month),
          'year': monthStart.year,
          'skillCount': snapshot.docs.length,
          'date': monthStart,
        });
      }

      return growthData;
    } catch (e) {
      throw Exception('Failed to get skills growth data: $e');
    }
  }

  // Get user registration data for charts (last 6 months)
  static Future<List<Map<String, dynamic>>> getUserRegistrationData() async {
    try {
      final now = DateTime.now();
      final registrationData = <Map<String, dynamic>>[];

      for (int i = 5; i >= 0; i--) {
        final monthStart = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 1).subtract(const Duration(days: 1));

        final snapshot = await _firestore
            .collection('users')
            .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart))
            .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(monthEnd))
            .get();

        registrationData.add({
          'month': _getMonthName(monthStart.month),
          'year': monthStart.year,
          'userCount': snapshot.docs.length,
          'date': monthStart,
        });
      }

      return registrationData;
    } catch (e) {
      throw Exception('Failed to get user registration data: $e');
    }
  }

  // Helper method to get month name
  static String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  // Generate comprehensive report data
  static Future<Map<String, dynamic>> generateReportData(String reportType) async {
    try {
      final analyticsData = await getAnalyticsData(period: 'monthly');
      
      switch (reportType) {
        case 'skills_inventory':
          return {
            'title': 'Skills Inventory Report',
            'data': analyticsData,
            'generatedAt': DateTime.now(),
            'summary': {
              'totalSkills': analyticsData['totalSkills'],
              'skillsByCategory': analyticsData['skillsByCategory'],
              'topSkills': analyticsData['topSkills'],
            }
          };
        
        case 'certification_status':
          return {
            'title': 'Certification Status Report',
            'data': analyticsData,
            'generatedAt': DateTime.now(),
            'summary': {
              'totalCertified': (analyticsData['allSkills'] as List<SkillModel>)
                  .where((s) => s.isVerified).length,
              'expiringSkills': analyticsData['expiringSkills'],
            }
          };
        
        case 'skills_gap':
          return {
            'title': 'Skills Gap Analysis Report',
            'data': analyticsData,
            'generatedAt': DateTime.now(),
            'summary': {
              'departmentStats': analyticsData['departmentStats'],
              'usersByDepartment': analyticsData['usersByDepartment'],
            }
          };
        
        case 'user_activity':
          return {
            'title': 'User Activity Report',
            'data': analyticsData,
            'generatedAt': DateTime.now(),
            'summary': {
              'mostActiveUsers': analyticsData['mostActiveUsers'],
              'trends': analyticsData['trends'],
            }
          };
        
        case 'proficiency_matrix':
          return {
            'title': 'Skills Proficiency Matrix Report',
            'data': analyticsData,
            'generatedAt': DateTime.now(),
            'summary': {
              'skillsByProficiency': analyticsData['skillsByProficiency'],
              'totalSkills': analyticsData['totalSkills'],
            }
          };
        
        default:
          throw Exception('Unknown report type: $reportType');
      }
    } catch (e) {
      throw Exception('Failed to generate report data: $e');
    }
  }

  // Real-time analytics stream
  static Stream<Map<String, dynamic>> getAnalyticsStream() {
    return Stream.periodic(const Duration(minutes: 5), (count) async {
      return await getAnalyticsData(period: 'monthly');
    }).asyncMap((future) => future);
  }}