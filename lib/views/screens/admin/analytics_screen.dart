// lib/views/screens/admin/analytics_screen.dart
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Monthly';
  final List<String> _periods = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
        actions: [
          DropdownButton<String>(
            value: _selectedPeriod,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            dropdownColor: const Color(0xFF2E7D6B),
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedPeriod = newValue;
                });
              }
            },
            items: _periods.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Skills', icon: Icon(Icons.star)),
            Tab(text: 'Users', icon: Icon(Icons.people)),
            Tab(text: 'Reports', icon: Icon(Icons.assessment)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSkillsTab(),
          _buildUsersTab(),
          _buildReportsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 20),

          // Key Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Total Skills',
                  value: '1,234',
                  trend: '+12.5%',
                  trendUp: true,
                  icon: Icons.star,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Active Users',
                  value: '245',
                  trend: '+8.2%',
                  trendUp: true,
                  icon: Icons.people_alt,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Certifications',
                  value: '892',
                  trend: '+15.3%',
                  trendUp: true,
                  icon: Icons.verified,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Expiring Soon',
                  value: '23',
                  trend: '-5.1%',
                  trendUp: false,
                  icon: Icons.warning,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Charts placeholder
          _buildChartCard(
            title: 'Skills Growth Trend',
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 48,
                      color: Color(0xFF2E7D6B),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Skills Growth Chart',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildChartCard(
            title: 'Department Distribution',
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart,
                      size: 48,
                      color: Color(0xFF2E7D6B),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Department Pie Chart',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 20),

          // Top Skills
          _buildListCard(
            title: 'Most Common Skills',
            items: [
              _buildSkillItem('Microsoft Excel', '156 users', '89%'),
              _buildSkillItem('Project Management', '134 users', '76%'),
              _buildSkillItem('Data Analysis', '98 users', '55%'),
              _buildSkillItem('Financial Modeling', '87 users', '49%'),
              _buildSkillItem('Leadership', '76 users', '43%'),
            ],
          ),

          const SizedBox(height: 16),

          // Skills by Proficiency
          _buildListCard(
            title: 'Skills by Proficiency Level',
            items: [
              _buildProficiencyItem('Expert', '234', Colors.green),
              _buildProficiencyItem('Advanced', '456', Colors.blue),
              _buildProficiencyItem('Intermediate', '789', Colors.orange),
              _buildProficiencyItem('Beginner', '321', Colors.red),
            ],
          ),

          const SizedBox(height: 16),

          // Expiring Certifications
          _buildListCard(
            title: 'Expiring Certifications (Next 30 Days)',
            items: [
              _buildExpiringItem('PMP Certification', '5 users', '15 days'),
              _buildExpiringItem('CPA License', '3 users', '22 days'),
              _buildExpiringItem('ACCA Qualification', '8 users', '28 days'),
              _buildExpiringItem('CFA Charter', '2 users', '30 days'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 20),

          // User Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Users', '245', Icons.people),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Active This Month', '198', Icons.person_outline),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard('New Users', '12', Icons.person_add),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Avg. Skills/User', '5.2', Icons.star_outline),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Users by Department
          _buildListCard(
            title: 'Users by Department',
            items: [
              _buildDepartmentItem('Finance', '45 users', '18%'),
              _buildDepartmentItem('Human Resources', '38 users', '15%'),
              _buildDepartmentItem('IT', '32 users', '13%'),
              _buildDepartmentItem('Procurement', '28 users', '11%'),
              _buildDepartmentItem('Operations', '25 users', '10%'),
              _buildDepartmentItem('Legal', '18 users', '7%'),
              _buildDepartmentItem('Other', '59 users', '24%'),
            ],
          ),

          const SizedBox(height: 16),

          // Most Active Users
          _buildListCard(
            title: 'Most Active Users (This Month)',
            items: [
              _buildUserActivityItem('John Doe', 'Finance', '15 skills updated'),
              _buildUserActivityItem('Sarah Smith', 'HR', '12 skills updated'),
              _buildUserActivityItem('Mike Johnson', 'IT', '10 skills updated'),
              _buildUserActivityItem('Lisa Brown', 'Legal', '8 skills updated'),
              _buildUserActivityItem('David Wilson', 'Operations', '7 skills updated'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Generate Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 20),

          // Report Types
          _buildReportCard(
            title: 'Skills Inventory Report',
            description: 'Complete list of all skills across all departments',
            icon: Icons.inventory,
            onTap: () => _generateReport('skills_inventory'),
          ),

          const SizedBox(height: 12),

          _buildReportCard(
            title: 'Certification Status Report',
            description: 'Overview of all certifications and their expiry dates',
            icon: Icons.verified,
            onTap: () => _generateReport('certification_status'),
          ),

          const SizedBox(height: 12),

          _buildReportCard(
            title: 'Department Skills Gap Analysis',
            description: 'Identify skill gaps by department',
            icon: Icons.analytics,
            onTap: () => _generateReport('skills_gap'),
          ),

          const SizedBox(height: 12),

          _buildReportCard(
            title: 'User Activity Report',
            description: 'Track user engagement and activity patterns',
            icon: Icons.timeline,
            onTap: () => _generateReport('user_activity'),
          ),

          const SizedBox(height: 12),

          _buildReportCard(
            title: 'Skills Proficiency Matrix',
            description: 'Matrix showing skill proficiency levels across users',
            icon: Icons.grid_view,
            onTap: () => _generateReport('proficiency_matrix'),
          ),

          const SizedBox(height: 24),

          const Text(
            'Recent Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Recent reports list
          _buildRecentReportItem(
            'Skills Inventory Report - December 2024',
            'Generated on Dec 15, 2024',
            Icons.file_download,
          ),
          _buildRecentReportItem(
            'Certification Status Report - November 2024',
            'Generated on Nov 30, 2024',
            Icons.file_download,
          ),
          _buildRecentReportItem(
            'Department Skills Gap Analysis - Q4 2024',
            'Generated on Nov 15, 2024',
            Icons.file_download,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required bool trendUp,
    required IconData icon,
    required Color color,
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
              Icon(icon, color: color, size: 24),
              Icon(
                trendUp ? Icons.trending_up : Icons.trending_down,
                color: trendUp ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            trend,
            style: TextStyle(
              fontSize: 12,
              color: trendUp ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildListCard({required String title, required List<Widget> items}) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
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
        children: [
          Icon(icon, size: 32, color: const Color(0xFF2E7D6B)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(String skill, String users, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              skill,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            users,
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
              percentage,
              style: const TextStyle(
                color: Color(0xFF2E7D6B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProficiencyItem(String level, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              level,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringItem(String certification, String users, String days) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certification,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  users,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              days,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentItem(String department, String users, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              department,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            users,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Text(
            percentage,
            style: const TextStyle(
              color: Color(0xFF2E7D6B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserActivityItem(String name, String department, String activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF2E7D6B).withOpacity(0.1),
            child: Text(
              name.split(' ').map((n) => n[0]).take(2).join(),
              style: const TextStyle(
                color: Color(0xFF2E7D6B),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  department,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            activity,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2E7D6B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2E7D6B),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReportItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D6B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _downloadReport(title),
            icon: const Icon(Icons.download),
            color: const Color(0xFF2E7D6B),
          ),
        ],
      ),
    );
  }

  void _generateReport(String reportType) {
    // TODO: Implement report generation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating $reportType report...'),
        backgroundColor: const Color(0xFF2E7D6B),
      ),
    );
  }

  void _downloadReport(String reportName) {
    // TODO: Implement report download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $reportName...'),
        backgroundColor: const Color(0xFF2E7D6B),
      ),
    );
  }
}