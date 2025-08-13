// lib/views/widgets/cards/user_card.dart
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewSkills;
  final bool showActions;
  final bool isCompact;
  final bool showSkillsCount;

  const UserCard({
    super.key,
    required this.userData,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewSkills,
    this.showActions = true,
    this.isCompact = false,
    this.showSkillsCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final name = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();
    final email = userData['email'] ?? '';
    final role = userData['role'] ?? 'user';
    final department = userData['department'] ?? '';
    final position = userData['position'] ?? '';
    final skillsCount = userData['skillsCount'] ?? 0;
    final profileImage = userData['profileImage'] as String?;
    final isActive = userData['isActive'] ?? true;
    final lastLogin = userData['lastLogin'] as DateTime?;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: isCompact ? 20 : 24,
                    backgroundColor: _getRoleColor(role).withOpacity(0.1),
                    backgroundImage: profileImage != null 
                        ? NetworkImage(profileImage) 
                        : null,
                    child: profileImage == null
                        ? Text(
                            _getInitials(name),
                            style: TextStyle(
                              color: _getRoleColor(role),
                              fontWeight: FontWeight.bold,
                              fontSize: isCompact ? 14 : 16,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name.isEmpty ? 'Unknown User' : name,
                                style: TextStyle(
                                  fontSize: isCompact ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (!isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'INACTIVE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (!isCompact && (position.isNotEmpty || department.isNotEmpty)) ...[
                          const SizedBox(height: 4),
                          Text(
                            [position, department].where((s) => s.isNotEmpty).join(' • '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getRoleColor(role),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  if (showActions) ...[
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'view_skills':
                            onViewSkills?.call();
                            break;
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view_skills',
                          child: Row(
                            children: [
                              Icon(Icons.psychology, size: 18),
                              SizedBox(width: 8),
                              Text('View Skills'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ],
                ],
              ),
              
              if (!isCompact) ...[
                const SizedBox(height: 16),
                
                // Stats Row
                Row(
                  children: [
                    if (showSkillsCount)
                      _buildStatChip(
                        icon: Icons.psychology,
                        label: 'Skills',
                        value: skillsCount.toString(),
                        color: Colors.blue,
                      ),
                    if (showSkillsCount && lastLogin != null)
                      const SizedBox(width: 12),
                    if (lastLogin != null)
                      _buildStatChip(
                        icon: Icons.access_time,
                        label: 'Last Login',
                        value: _formatDate(lastLogin),
                        color: Colors.green,
                      ),
                  ],
                ),
                
                if (department.isNotEmpty && position.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$position - $department',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'manager':
        return Colors.orange;
      case 'supervisor':
        return Colors.blue;
      case 'user':
      default:
        return const Color(0xFF2E7D6B);
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }
  }
}

class UserSummaryCard extends StatelessWidget {
  final Map<String, dynamic> summaryData;
  final VoidCallback? onViewAll;

  const UserSummaryCard({
    super.key,
    required this.summaryData,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final totalUsers = summaryData['totalUsers'] ?? 0;
    final activeUsers = summaryData['activeUsers'] ?? 0;
    final adminUsers = summaryData['adminUsers'] ?? 0;
    final newUsersThisMonth = summaryData['newUsersThisMonth'] ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Total Users',
                    totalUsers.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Active',
                    activeUsers.toString(),
                    Icons.person,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Admins',
                    adminUsers.toString(),
                    Icons.admin_panel_settings,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'New This Month',
                    newUsersThisMonth.toString(),
                    Icons.person_add,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}