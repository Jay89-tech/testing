// lib/views/screens/admin/user_management_screen.dart
import 'package:flutter/material.dart';
import '/services/firebase/firestore_service.dart'; // Ensure this path is correct
import '/models/user_model.dart'; // Ensure this path is correct
// import 'analytics_screen.dart'; // Uncomment if needed
// import 'admin_dashboard_screen.dart'; // Uncomment if needed
// import '/utils/constants/app_constants.dart'; // Uncomment if needed
// import '/models/themes/app_theme.dart'; // Uncomment if needed


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

  // Controllers for adding new user dialog
  final TextEditingController _addNameController = TextEditingController();
  final TextEditingController _addEmailController = TextEditingController();
  final TextEditingController _addDepartmentController = TextEditingController();
  final TextEditingController _addRoleController = TextEditingController();

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
    _addNameController.dispose();
    _addEmailController.dispose();
    _addDepartmentController.dispose();
    _addRoleController.dispose();
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
    return StreamBuilder<List<UserModel>>(
      stream: FirestoreService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data ?? [];
        final filteredUsers = _getFilteredUsers(users);
        final activeUsers = users.where((user) => user.userType != 'Inactive').length;
        final inactiveUsers = users.length - activeUsers;

        return Column(
          children: [
            // Search and Filter Bar (keep existing)
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

            // User Stats (updated with real data)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildUserStatCard('Total Users', '${users.length}', Icons.people, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUserStatCard('Active', '$activeUsers', Icons.check_circle, Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUserStatCard('Inactive', '$inactiveUsers', Icons.pause_circle, Colors.orange),
                  ),
                ],
              ),
            ),

            // Users List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return _buildUserCard(user);
                },
              ),
            ),
          ],
        );
      },
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
    // This part still uses static data. To make it dynamic, you'd need
    // an 'AuditLog' model and a corresponding stream/service from Firestore.
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

  Widget _buildUserCard(UserModel user) {
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
            user.name.split(' ').map((n) => n[0]).take(2).join(),
            style: const TextStyle(
              color: Color(0xFF2E7D6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildUserBadge(user.department, Colors.blue),
                const SizedBox(width: 8),
                _buildUserBadge(user.userType, Colors.green),
                const SizedBox(width: 8),
                // The status needs to be part of the UserModel if you want dynamic status display
                _buildUserBadge(
                  user.userType, // Assuming userType can also represent active/inactive
                  user.userType != 'Inactive' ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Joined: ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year} • ${user.skills.length} skills',
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
              value: user.userType != 'Inactive' ? 'deactivate' : 'activate',
              child: Text(user.userType != 'Inactive' ? 'Deactivate' : 'Activate'),
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

  List<UserModel> _getFilteredUsers(List<UserModel> users) {
    return users.where((user) {
      final matchesSearch = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery);
      
      final matchesDepartment = _selectedDepartment == 'All Departments' ||
          user.department == _selectedDepartment;
      
      final matchesRole = _selectedRole == 'All Roles' ||
          user.userType == _selectedRole; // Assuming userType is used for role
      
      return matchesSearch && matchesDepartment && matchesRole;
    }).toList();
  }

  void _showAddUserDialog() {
    // Clear controllers before showing the dialog
    _addNameController.clear();
    _addEmailController.clear();
    _addDepartmentController.clear();
    _addRoleController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDepartment == 'All Departments' ? null : _selectedDepartment, // Set initial value
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _departments.where((d) => d != 'All Departments').map((dept) {
                  return DropdownMenuItem(value: dept, child: Text(dept));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _addDepartmentController.text = value!;
                  });
                },
                hint: const Text('Select Department'), // Add a hint
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole == 'All Roles' ? null : _selectedRole, // Set initial value
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _roles.where((r) => r != 'All Roles').map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _addRoleController.text = value!;
                  });
                },
                hint: const Text('Select Role'), // Add a hint
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
            onPressed: () async {
              try {
                // Basic validation
                if (_addNameController.text.isEmpty ||
                    _addEmailController.text.isEmpty ||
                    _addDepartmentController.text.isEmpty ||
                    _addRoleController.text.isEmpty) {
                  _showErrorSnackBar('Please fill all fields.');
                  return;
                }

                // Create a new UserModel
                final newUser = UserModel(
                  id: '', // Firestore will assign an ID
                  name: _addNameController.text.trim(),
                  email: _addEmailController.text.trim(),
                  department: _addDepartmentController.text.trim(),
                  userType: _addRoleController.text.trim(), // Assuming 'userType' is used for role
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  lastLogin: DateTime.now(),
                  skills: [], // Initialize with empty skills
                );

                await FirestoreService.addUser(newUser);
                Navigator.pop(context);
                _showSuccessSnackBar('User added successfully');
              } catch (e) {
                Navigator.pop(context);
                _showErrorSnackBar('Failed to add user: $e');
              }
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog(UserModel user) {
    String tempSelectedRole = user.userType; // Use a temporary variable for the dialog's state

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder to update the dialog's state
          builder: (context, setStateInsideDialog) {
            return AlertDialog(
              title: Text('Manage Permissions - ${user.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current Role: ${user.userType}'),
                  const SizedBox(height: 16),
                  const Text('Select new role:'),
                  const SizedBox(height: 8),
                  ..._roles.where((r) => r != 'All Roles').map((role) => 
                    RadioListTile<String>(
                      title: Text(role),
                      value: role,
                      groupValue: tempSelectedRole,
                      onChanged: (value) {
                        setStateInsideDialog(() { // Update the dialog's local state
                          tempSelectedRole = value!;
                        });
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
                  onPressed: () async {
                    try {
                      final updatedUser = user.copyWith(
                        userType: tempSelectedRole,
                        updatedAt: DateTime.now(),
                      );
                      await FirestoreService.updateUser(updatedUser);
                      Navigator.pop(context);
                      _showSuccessSnackBar('Permissions updated successfully');
                    } catch (e) {
                      Navigator.pop(context);
                      _showErrorSnackBar('Failed to update permissions: $e');
                    }
                  },
                  child: const Text('Update Permissions'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _resetPassword(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text('Are you sure you want to reset the password for ${user.name}?\n\nA temporary password will be sent to ${user.email}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Implement Firebase Auth password reset here
                // For example: await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);
                Navigator.pop(context);
                _showSuccessSnackBar('Password reset email sent to ${user.email}');
              } catch (e) {
                Navigator.pop(context);
                _showErrorSnackBar('Failed to send password reset email: $e');
              }
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  void _toggleUserStatus(UserModel user) {
    final isActive = user.userType != 'Inactive'; // Assuming 'Inactive' is the status for inactive users
    final action = isActive ? 'deactivate' : 'activate';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isActive ? 'Deactivate' : 'Activate'} User'),
        content: Text('Are you sure you want to $action ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedUser = user.copyWith(
                  userType: isActive ? 'Inactive' : 'Employee', // Set to a default active role if activating
                  updatedAt: DateTime.now(),
                );
                await FirestoreService.updateUser(updatedUser);
                Navigator.pop(context);
                _showSuccessSnackBar('User ${isActive ? 'deactivated' : 'activated'} successfully');
              } catch (e) {
                Navigator.pop(context);
                _showErrorSnackBar('Failed to change user status: $e');
              }
            },
            child: Text(isActive ? 'Deactivate' : 'Activate'),
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleUserAction(String action, UserModel user) {
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

  void _showEditUserDialog(UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final departmentController = TextEditingController(text: user.department);
    final roleController = TextEditingController(text: user.userType);


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
                controller: nameController,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
                enabled: false, // Email shouldn't be editable
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: departmentController.text.isEmpty ? null : departmentController.text,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _departments.where((d) => d != 'All Departments').map((dept) {
                  return DropdownMenuItem(value: dept, child: Text(dept));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    departmentController.text = value!;
                  });
                },
                hint: const Text('Select Department'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: roleController.text.isEmpty ? null : roleController.text,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _roles.where((r) => r != 'All Roles').map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roleController.text = value!;
                  });
                },
                hint: const Text('Select Role'),
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
            onPressed: () async {
              try {
                final updatedUser = user.copyWith(
                  name: nameController.text.trim(),
                  department: departmentController.text.trim(),
                  userType: roleController.text.trim(),
                  updatedAt: DateTime.now(),
                );
                
                await FirestoreService.updateUser(updatedUser);
                Navigator.pop(context);
                _showSuccessSnackBar('User updated successfully');
              } catch (e) {
                Navigator.pop(context);
                _showErrorSnackBar('Failed to update user: $e');
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete ${user.name}?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone. All user data including skills will be permanently deleted.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}