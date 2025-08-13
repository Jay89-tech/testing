// lib/views/screens/admin/user_management_screen.dart
import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDepartment = 'All Departments';
  String _selectedRole = 'All Roles';
  
  final List<String> _departments = [
    'All Departments',
    'Finance',
    'Human Resources',
    'Information Technology',
    'Procurement',
    'Operations',
    'Legal',
    'Administration',
  ];
  
  final List<String> _roles = [
    'All Roles',
    'Administrator',
    'Manager',
    'Employee',
    'Guest',
  ];

  // Sample user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@treasury.gov.za',
      'department': 'Finance',
      'role': 'Manager',
      'status': 'Active',
      'lastLogin': '2024-12-15',
      'skillsCount': 12,
      'joinDate': '2023-01-15',
    },
    {
      'id': '2',
      'name': 'Sarah Smith',
      'email': 'sarah.smith@treasury.gov.za',
      'department': 'Human Resources',
      'role': 'Administrator',
      'status': 'Active',
      'lastLogin': '2024-12-14',
      'skillsCount': 8,
      'joinDate': '2022-03-20',
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'email': 'mike.johnson@treasury.gov.za',
      'department': 'Information Technology',
      'role': 'Employee',
      'status': 'Active',
      'lastLogin': '2024-12-13',
      'skillsCount': 15,
      'joinDate': '2023-06-10',
    },
    {
      'id': '4',
      'name': 'Lisa Brown',
      'email': 'lisa.brown@treasury.gov.za',
      'department': 'Legal',
      'role': 'Manager',
      'status': 'Inactive',
      'lastLogin': '2024-11-28',
      'skillsCount': 6,
      'joinDate': '2022-09-05',
    },
    {
      'id': '5',
      'name': 'David Wilson',
      'email': 'david.wilson@treasury.gov.za',
      'department': 'Operations',
      'role': 'Employee',
      'status': 'Active',
      'lastLogin': '2024-12-12',
      'skillsCount': 9,
      'joinDate': '2023-11-15',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            onPressed: _showAddUserDialog,
            icon: const Icon(Icons.person_add),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Users', icon: Icon(Icons.people)),
            Tab(text: 'Permissions', icon: Icon(Icons.security)),
            Tab(text: 'Audit Log', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(),
          _buildPermissionsTab(),
          _buildAuditLogTab(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return Column(
      children: [
        // Search and Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[50],
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users by name or email...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _departments.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _roles.map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // User Stats
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildUserStatCard('Total Users', '245', Icons.people, Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUserStatCard('Active', '198', Icons.check_circle, Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUserStatCard('Inactive', '47', Icons.pause_circle, Colors.orange),
              ),
            ],
          ),
        ),

        // Users List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _getFilteredUsers().length,
            itemBuilder: (context, index) {
              final user = _getFilteredUsers()[index];
              return _buildUserCard(user);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role Permissions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 20),

          _buildPermissionCard(
            role: 'Administrator',
            description: 'Full system access with all privileges',
            permissions: [
              'Create, edit, and delete users',
              'Access all analytics and reports',
              'Manage system settings',
              'View all user skills',
              'Export data',
            ],
            color: Colors.red,
          ),

          const SizedBox(height: 16),

          _buildPermissionCard(
            role: 'Manager',
            description: 'Department-level management access',
            permissions: [
              'View department user skills',
              'Generate department reports',
              'Approve skill submissions',
              'View analytics for department',
            ],
            color: Colors.orange,
          ),

          const SizedBox(height: 16),

          _buildPermissionCard(
            role: 'Employee',
            description: 'Standard user access',
            permissions: [
              'Add and edit own skills',
              'Upload certifications',
              'View personal analytics',
              'Update profile information',
            ],
            color: Colors.blue,
          ),

          const SizedBox(height: 16),

          _buildPermissionCard(
            role: 'Guest',
            description: 'Limited read-only access',
            permissions: [
              'View own profile',
              'View basic system information',
            ],
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLogTab() {
    final auditLogs = [
      {
        'timestamp': '2024-12-15 14:30:25',
        'user': 'Sarah Smith',
        'action': 'User Created',
        'details': 'Created new user: Mike Johnson',
        'ipAddress': '192.168.1.100',
      },
      {
        'timestamp': '2024-12-15 11:15:10',
        'user': 'John Doe',
        'action': 'Role Changed',
        'details': 'Changed Lisa Brown role from Employee to Manager',
        'ipAddress': '192.168.1.101',
      },
      {
        'timestamp': '2024-12-14 16:45:33',
        'user': 'Admin System',
        'action': 'User Login',
        'details': 'David Wilson logged in successfully',
        'ipAddress': '192.168.1.102',
      },
      {
        'timestamp': '2024-12-14 09:22:15',
        'user': 'Sarah Smith',
        'action': 'User Deactivated',
        'details': 'Deactivated user: Tom Anderson',
        'ipAddress': '192.168.1.100',
      },
      {
        'timestamp': '2024-12-13 13:30:45',
        'user': 'John Doe',
        'action': 'Permission Updated',
        'details': 'Updated permissions for Finance department',
        'ipAddress': '192.168.1.101',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Audit Log',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track all user management activities and system changes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),

          ...auditLogs.map((log) => _buildAuditLogItem(log)).toList(),
        ],
      ),
    );
  }

  Widget _buildUserStatCard(String title, String value, IconData icon, Color color) {
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
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF2E7D6B).withOpacity(0.1),
          child: Text(
            user['name'].toString().split(' ').map((n) => n[0]).take(2).join(),
            style: const TextStyle(
              color: Color(0xFF2E7D6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email']),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildUserBadge(user['department'], Colors.blue),
                const SizedBox(width: 8),
                _buildUserBadge(user['role'], Colors.green),
                const SizedBox(width: 8),
                _buildUserBadge(
                  user['status'], 
                  user['status'] == 'Active' ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Last login: ${user['lastLogin']} • ${user['skillsCount']} skills',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleUserAction(value, user),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit User')),
            const PopupMenuItem(value: 'permissions', child: Text('Manage Permissions')),
            const PopupMenuItem(value: 'reset_password', child: Text('Reset Password')),
            PopupMenuItem(
              value: user['status'] == 'Active' ? 'deactivate' : 'activate',
              child: Text(user['status'] == 'Active' ? 'Deactivate' : 'Activate'),
            ),
            const PopupMenuItem(value: 'delete', child: Text('Delete User')),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required String role,
    required String description,
    required List<String> permissions,
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _editPermissions(role),
                icon: const Icon(Icons.edit),
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Permissions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...permissions.map((permission) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.check, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    permission,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAuditLogItem(Map<String, dynamic> log) {
    Color actionColor;
    IconData actionIcon;
    
    switch (log['action']) {
      case 'User Created':
        actionColor = Colors.green;
        actionIcon = Icons.person_add;
        break;
      case 'Role Changed':
        actionColor = Colors.orange;
        actionIcon = Icons.security;
        break;
      case 'User Login':
        actionColor = Colors.blue;
        actionIcon = Icons.login;
        break;
      case 'User Deactivated':
        actionColor = Colors.red;
        actionIcon = Icons.person_remove;
        break;
      case 'Permission Updated':
        actionColor = Colors.purple;
        actionIcon = Icons.edit;
        break;
      default:
        actionColor = Colors.grey;
        actionIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: actionColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              actionIcon,
              color: actionColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      log['action'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: actionColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${log['user']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  log['details'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${log['timestamp']} • IP: ${log['ipAddress']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    return _users.where((user) {
      final matchesSearch = _searchQuery.isEmpty ||
          user['name'].toString().toLowerCase().contains(_searchQuery) ||
          user['email'].toString().toLowerCase().contains(_searchQuery);
      
      final matchesDepartment = _selectedDepartment == 'All Departments' ||
          user['department'] == _selectedDepartment;
      
      final matchesRole = _selectedRole == 'All Roles' ||
          user['role'] == _selectedRole;
      
      return matchesSearch && matchesDepartment && matchesRole;
    }).toList();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('User added successfully');
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Permissions - ${user['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Role: ${user['role']}'),
            const SizedBox(height: 16),
            const Text('Select new role:'),
            const SizedBox(height: 8),
            ...['Administrator', 'Manager', 'Employee', 'Guest'].map((role) => 
              RadioListTile<String>(
                title: Text(role),
                value: role,
                groupValue: user['role'],
                onChanged: (value) {
                  // Handle role change
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Permissions updated successfully');
            },
            child: const Text('Update Permissions'),
          ),
        ],
      ),
    );
  }

  void _resetPassword(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text('Are you sure you want to reset the password for ${user['name']}?\n\nA temporary password will be sent to ${user['email']}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Password reset email sent to ${user['email']}');
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    final isActive = user['status'] == 'Active';
    final action = isActive ? 'deactivate' : 'activate';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isActive ? 'Deactivate' : 'Activate'} User'),
        content: Text('Are you sure you want to $action ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                user['status'] = isActive ? 'Inactive' : 'Active';
              });
              _showSuccessSnackBar('User ${isActive ? 'deactivated' : 'activated'} successfully');
            },
            child: Text(isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete ${user['name']}?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone. All user data including skills and certifications will be permanently deleted.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              _showSuccessSnackBar('User deleted successfully');
            },
            child: const Text('Delete User'),
          ),
        ],
      ),
    );
  }

  void _editPermissions(String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $role Permissions'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                value: true,
                onChanged: null,
                title: Text('View Dashboard'),
              ),
              CheckboxListTile(
                value: true,
                onChanged: null,
                title: Text('Manage Skills'),
              ),
              CheckboxListTile(
                value: false,
                onChanged: null,
                title: Text('User Management'),
              ),
              CheckboxListTile(
                value: false,
                onChanged: null,
                title: Text('System Settings'),
              ),
              // Add more permissions as needed
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Permissions updated successfully');
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2E7D6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'permissions':
        _showPermissionsDialog(user);
        break;
      case 'reset_password':
        _resetPassword(user);
        break;
      case 'activate':
      case 'deactivate':
        _toggleUserStatus(user);
        break;
      case 'delete':
        _showDeleteConfirmation(user);
        break;
    }
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: user['name']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: user['email']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: user['department']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: user['role']),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('User updated successfully');
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}