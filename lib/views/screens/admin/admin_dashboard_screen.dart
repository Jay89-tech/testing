// lib/views/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../../utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/views/screens/auth_screen.dart';
import '../../../services/analytics_service.dart';
import '../../../models/user_model.dart';
import '../../../models/skill_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _analyticsData = {};
  
  // Real-time data variables
  int _totalUsers = 0;
  int _totalSkills = 0;
  int _totalCertifications = 0;
  int _expiringSoon = 0;
  double _userGrowthRate = 0.0;
  double _skillGrowthRate = 0.0;
  List<Map<String, dynamic>> _topDepartments = [];
  List<Map<String, dynamic>> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    
    // Set up periodic refresh every 30 seconds
    _setupPeriodicRefresh();
  }

  void _setupPeriodicRefresh() {
    Stream.periodic(const Duration(seconds: 30)).listen((_) {
      if (mounted) {
        _loadDashboardData();
      }
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() => _isLoading = true);
      
      final data = await AnalyticsService.getAnalyticsData(period: 'monthly');
      final allUsers = data['allUsers'] as List<UserModel>;
      final allSkills = data['allSkills'] as List<SkillModel>;
      final trends = data['trends'] as Map<String, double>;
      
      setState(() {
        _analyticsData = data;
        _totalUsers = allUsers.length;
        _totalSkills = allSkills.length;
        _totalCertifications = allSkills.where((s) => s.isVerified).length;
        _expiringSoon = (data['expiringSkills'] as List<SkillModel>).length;
        _userGrowthRate = trends['userGrowthRate'] ?? 0.0;
        _skillGrowthRate = trends['skillGrowthRate'] ?? 0.0;
        
        // Process top departments
        _topDepartments = _processTopDepartments(data['usersByDepartment'] as Map<String, int>);
        
        // Process recent activity
        _recentActivity = _processRecentActivity(allUsers, allSkills);
        
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _processTopDepartments(Map<String, int> usersByDepartment) {
    final sorted = usersByDepartment.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(3).map((entry) => {
      'name': entry.key,
      'userCount': entry.value,
      'percentage': _totalUsers > 0 ? ((entry.value / _totalUsers) * 100).toStringAsFixed(0) : '0',
    }).toList();
  }

  List<Map<String, dynamic>> _processRecentActivity(List<UserModel> users, List<SkillModel> skills) {
    final recentUsers = users.take(3).toList();
    final recentSkills = skills.take(3).toList();
    final activity = <Map<String, dynamic>>[];
    
    // Add recent user registrations
    for (final user in recentUsers) {
      activity.add({
        'type': 'user_joined',
        'title': 'New User Registered',
        'subtitle': '${user.name} joined ${user.department}',
        'time': _formatTime(user.createdAt),
        'icon': Icons.person_add,
        'color': Colors.green,
      });
    }
    
    // Add recent skills
    for (final skill in recentSkills) {
      final user = users.firstWhere((u) => u.id == skill.userId, 
        orElse: () => UserModel(
          id: '', name: 'Unknown User', email: '', department: '', 
          userType: '', skills: [], createdAt: DateTime.now()
        ));
      
      activity.add({
        'type': 'skill_added',
        'title': 'New Skill Added',
        'subtitle': '${user.name} added ${skill.name}',
        'time': _formatTime(skill.createdAt),
        'icon': Icons.star_border,
        'color': Colors.blue,
      });
    }
    
    // Sort by creation time
    activity.sort((a, b) => b['time'].compareTo(a['time']));
    
    return activity.take(5).toList();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF2E7D6B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2E7D6B),
            ),
          )
        : RefreshIndicator(
            onRefresh: _loadDashboardData,
            color: const Color(0xFF2E7D6B),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header with Live Data
                  _buildWelcomeHeader(),
                  const SizedBox(height: 24),
                  
                  // Live Stats Cards
                  _buildLiveStatsSection(),
                  const SizedBox(height: 24),
                  
                  // Quick Insights
                  _buildQuickInsightsSection(),
                  const SizedBox(height: 24),
                  
                  // Recent Activity
                  _buildRecentActivitySection(),
                  const SizedBox(height: 24),
                  
                  // Management Tools
                  _buildManagementToolsSection(),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D6B), Color(0xFF45A089)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D6B).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back, Administrator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Here\'s what\'s happening with your Skills Audit System',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last updated: ${DateTime.now().toString().substring(0, 16)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Live System Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D6B),
          ),
        ),
        const SizedBox(height: 16),
        
        // First row
        Row(
          children: [
            Expanded(
              child: _buildLiveStatsCard(
                title: 'Total Users',
                value: _totalUsers.toString(),
                trend: '${_userGrowthRate > 0 ? '+' : ''}${_userGrowthRate.toStringAsFixed(1)}%',
                trendUp: _userGrowthRate >= 0,
                icon: Icons.people,
                color: Colors.blue,
                subtitle: 'Active accounts',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLiveStatsCard(
                title: 'Total Skills',
                value: _totalSkills.toString(),
                trend: '${_skillGrowthRate > 0 ? '+' : ''}${_skillGrowthRate.toStringAsFixed(1)}%',
                trendUp: _skillGrowthRate >= 0,
                icon: Icons.star,
                color: Colors.green,
                subtitle: 'Skills recorded',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Second row
        Row(
          children: [
            Expanded(
              child: _buildLiveStatsCard(
                title: 'Certifications',
                value: _totalCertifications.toString(),
                trend: '${((_totalCertifications / (_totalSkills > 0 ? _totalSkills : 1)) * 100).toStringAsFixed(0)}%',
                trendUp: true,
                icon: Icons.verified,
                color: Colors.orange,
                subtitle: 'Verified skills',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLiveStatsCard(
                title: 'Expiring Soon',
                value: _expiringSoon.toString(),
                trend: 'Next 30 days',
                trendUp: false,
                icon: Icons.warning,
                color: _expiringSoon > 0 ? Colors.red : Colors.green,
                subtitle: 'Need attention',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D6B),
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Color(0xFF2E7D6B)),
                  const SizedBox(width: 8),
                  const Text(
                    'Top Performing Departments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              ..._topDepartments.map((dept) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dept['name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      '${dept['userCount']} users',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D6B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${dept['percentage']}%',
                        style: const TextStyle(
                          color: Color(0xFF2E7D6B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D6B),
              ),
            ),
            TextButton(
              onPressed: () => AppRoutes.navigateTo(context, AppRoutes.analytics),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _recentActivity.isEmpty 
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : Column(
                children: _recentActivity.map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (activity['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          activity['icon'],
                          color: activity['color'],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              activity['subtitle'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        activity['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
        ),
      ],
    );
  }

  Widget _buildManagementToolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D6B),
          ),
        ),
        const SizedBox(height: 16),
        
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _buildManagementCard(
              title: 'User Management',
              subtitle: 'Manage $_totalUsers user accounts',
              icon: Icons.manage_accounts,
              onTap: () => AppRoutes.navigateTo(context, AppRoutes.userManagement),
              badge: _analyticsData['newUsersCount']?.toString(),
            ),
            _buildManagementCard(
              title: 'Analytics',
              subtitle: 'View detailed reports',
              icon: Icons.analytics,
              onTap: () => AppRoutes.navigateTo(context, AppRoutes.analytics),
              badge: null,
            ),
            _buildManagementCard(
              title: 'Skills Overview',
              subtitle: 'Browse $_totalSkills skills',
              icon: Icons.list_alt,
              onTap: () => AppRoutes.navigateTo(context, AppRoutes.skillsList),
              badge: _analyticsData['newSkillsCount']?.toString(),
            ),
            _buildManagementCard(
              title: 'System Settings',
              subtitle: 'Configure preferences',
              icon: Icons.settings,
              onTap: () => AppRoutes.navigateTo(context, AppRoutes.settings),
              badge: _expiringSoon > 0 ? _expiringSoon.toString() : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveStatsCard({
    required String title,
    required String value,
    required String trend,
    required bool trendUp,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              if (trend.contains('%'))
                Icon(
                  trendUp ? Icons.trending_up : Icons.trending_down,
                  color: trendUp ? Colors.green : Colors.red,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                trend,
                style: TextStyle(
                  fontSize: 12,
                  color: trend.contains('%') 
                    ? (trendUp ? Colors.green : Colors.red)
                    : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (trend.contains('%'))
                Text(
                  ' this month',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: const Color(0xFF2E7D6B),
                ),
                if (badge != null && badge != '0')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D6B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}