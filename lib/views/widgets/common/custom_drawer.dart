// lib/views/widgets/common/custom_drawer.dart
import 'package:flutter/material.dart';
import '../../../utils/routes.dart';
import '../../../services/local/shared_preferences_service.dart';

class CustomDrawer extends StatelessWidget {
  final String? currentRoute;

  const CustomDrawer({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final userData = SharedPreferencesService.getUserData();
    final isAdmin = SharedPreferencesService.isAdmin();
    final userName = userData != null 
        ? '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim()
        : 'User';
    final userEmail = userData?['email'] ?? '';

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(userName, userEmail, isAdmin),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.home,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  title: 'Profile',
                  route: AppRoutes.profile,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.psychology_outlined,
                  activeIcon: Icons.psychology,
                  title: 'My Skills',
                  route: AppRoutes.skillsList,
                ),
                
                const Divider(height: 1),
                
                if (isAdmin) ...[
                  _buildSectionHeader('Administration'),
                  _buildDrawerItem(
                    context,
                    icon: Icons.analytics_outlined,
                    activeIcon: Icons.analytics,
                    title: 'Analytics',
                    route: AppRoutes.analytics,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    title: 'User Management',
                    route: AppRoutes.userManagement,
                  ),
                  
                  const Divider(height: 1),
                ],
                
                _buildSectionHeader('Other'),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  activeIcon: Icons.info,
                  title: 'About',
                  route: AppRoutes.about,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.contact_support_outlined,
                  activeIcon: Icons.contact_support,
                  title: 'Contact',
                  route: AppRoutes.contact,
                ),
              ],
            ),
          ),
          
          // Footer
          const Divider(height: 1),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(String userName, String userEmail, bool isAdmin) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D6B),
            Color(0xFF4A9B8A),
          ],
        ),
      ),
      child: DrawerHeader(
        decoration: const BoxDecoration(color: Colors.transparent),
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                _getInitials(userName),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName.isEmpty ? 'User' : userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            if (isAdmin) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: const Text(
                  'ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String route,
    int? badgeCount,
  }) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? const Color(0xFF2E7D6B).withOpacity(0.1) : null,
      ),
      child: ListTile(
        leading: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? const Color(0xFF2E7D6B) : Colors.grey[600],
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF2E7D6B) : Colors.grey[800],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: badgeCount != null && badgeCount > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
        onTap: () {
          Navigator.pop(context); // Close drawer
          if (!isActive) {
            AppRoutes.navigateTo(context, route);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: const Icon(
          Icons.logout,
          color: Colors.red,
          size: 24,
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onTap: () => _showLogoutDialog(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    // Clear user data
    await SharedPreferencesService.clearUserData();
    
    // Navigate to auth screen and clear stack
    AppRoutes.navigateToAndClearStack(context, AppRoutes.auth);
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class DrawerMenuItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final String route;
  final int? badgeCount;
  final bool isAdmin;
  final VoidCallback? onTap;

  const DrawerMenuItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.route,
    this.badgeCount,
    this.isAdmin = false,
    this.onTap,
  });
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showAdmin;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.psychology_outlined),
        activeIcon: Icon(Icons.psychology),
        label: 'Skills',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
      if (showAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFF2E7D6B),
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: items,
    );
  }
}