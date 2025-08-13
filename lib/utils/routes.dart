// lib/utils/routes.dart
import 'package:flutter/material.dart';
import '../views/screens/splash_screen.dart';
import '../views/screens/auth_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/profile_screen.dart';
import '../views/screens/skills/skills_list_screen.dart';
import '../views/screens/skills/add_skill_screen.dart';
import '../views/screens/skills/edit_skill_screen.dart';
import '../views/screens/admin/admin_dashboard_screen.dart';
import '../views/screens/admin/analytics_screen.dart';
import '../views/screens/admin/user_management_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String skillsList = '/skills-list';
  static const String addSkill = '/add-skill';
  static const String editSkill = '/edit-skill';
  static const String skillDetails = '/skill-details';
  static const String analytics = '/analytics';
  static const String userManagement = '/user-management';
  static const String adminDashboard = '/admin-dashboard';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String contact = '/contact';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      case skillsList:
        return MaterialPageRoute(
          builder: (_) => const SkillsListScreen(),
          settings: settings,
        );

      case addSkill:
        return MaterialPageRoute(
          builder: (_) => const AddSkillScreen(),
          settings: settings,
        );

      case editSkill:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditSkillScreen(
            skill: args?['skill'],
          ),
          settings: settings,
        );

      case skillDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SkillDetailsScreen(
            skillData: args?['skillData'],
          ),
          settings: settings,
        );

      case analytics:
        return MaterialPageRoute(
          builder: (_) => const AnalyticsScreen(),
          settings: settings,
        );

      /*case userManagement:
        return MaterialPageRoute(
          builder: (_) => const UserManagementScreen(),
          settings: settings,
        );*/

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
          settings: settings,
        );

      /*case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );*/

      case about:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
          settings: settings,
        );

      case contact:
        return MaterialPageRoute(
          builder: (_) => const ContactScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }

  // Navigation helpers
  static void navigateToAndClearStack(BuildContext context, String routeName) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  static void navigateToAndReplacement(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static bool canNavigateBack(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}

// Updated placeholder screens for routes that don't exist yet
class SkillDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? skillData;

  const SkillDetailsScreen({super.key, this.skillData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Details'),
      ),
      body: const Center(
        child: Text('Skill Details Screen - Coming Soon'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D6B),
              ),
            ),
            const SizedBox(height: 20),

            _buildSettingsSection(
              title: 'Account',
              children: [
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Profile Settings',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.profile);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.security,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () {
                    // TODO: Navigate to change password screen
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications about skills updates',
                  value: true,
                  onChanged: (value) {
                    // TODO: Handle notification toggle
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates about expiring skills',
                  value: false,
                  onChanged: (value) {
                    // TODO: Handle email notification toggle
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: 'Appearance',
              children: [
                _buildSettingsTile(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: 'Light theme',
                  onTap: () {
                    // TODO: Show theme selection dialog
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {
                    // TODO: Show language selection dialog
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: 'Data & Storage',
              children: [
                _buildSettingsTile(
                  icon: Icons.download,
                  title: 'Export Data',
                  subtitle: 'Download your skills data',
                  onTap: () {
                    _showExportDialog(context);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.storage,
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  onTap: () {
                    _showClearCacheDialog(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: 'Support',
              children: [
                _buildSettingsTile(
                  icon: Icons.help,
                  title: 'Help & FAQ',
                  subtitle: 'Get help using the app',
                  onTap: () {
                    _showHelpDialog(context);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.contact_support,
                  title: 'Contact Support',
                  subtitle: 'Get in touch with our team',
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.contact);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    AppRoutes.navigateTo(context, AppRoutes.about);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSettingsSection(
              title: 'Advanced',
              children: [
                _buildSettingsTile(
                  icon: Icons.sync,
                  title: 'Sync Settings',
                  subtitle: 'Manage data synchronization',
                  onTap: () {
                    // TODO: Show sync settings
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.backup,
                  title: 'Backup & Restore',
                  subtitle: 'Manage your data backups',
                  onTap: () {
                    // TODO: Show backup settings
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Logout button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: TextButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App version
            const Center(
              child: Text(
                'Skills Audit System v1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D6B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
            children: children,
          ),
        ),
      ],
    );
  }

  static Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D6B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2E7D6B),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  static Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D6B).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2E7D6B),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2E7D6B),
      ),
    );
  }

  static void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'This will download all your skills data as a PDF report. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting data...'),
                  backgroundColor: Color(0xFF2E7D6B),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  static void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear temporary files and free up storage space. Your data will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Color(0xFF2E7D6B),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  static void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & FAQ'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Frequently Asked Questions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('Q: How do I add a new skill?'),
              Text('A: Navigate to Skills > Add New Skill and fill in the details.'),
              SizedBox(height: 8),
              Text('Q: How do I upload certifications?'),
              Text('A: When adding/editing a skill, use the "Upload Certificate" button.'),
              SizedBox(height: 8),
              Text('Q: Can I edit my profile?'),
              Text('A: Yes, go to Profile > Edit Profile to update your information.'),
              SizedBox(height: 12),
              Text(
                'For more help, contact our support team.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
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
              AppRoutes.navigateToAndClearStack(context, AppRoutes.auth);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 80,
              color: Color(0xFF2E7D6B),
            ),
            const SizedBox(height: 20),
            Text(
              '$title Coming Soon',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D6B),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This feature is under development\nand will be available soon.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills Audit System',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D6B),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'The Skills Audit System is designed to help the National Treasury track and manage employee skills effectively. This digital solution replaces outdated manual systems with a modern, centralized platform.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('• Add and manage personal skills'),
            Text('• Track skill proficiency levels'),
            Text('• Upload certifications'),
            Text('• Analytics and reporting (Admin)'),
            Text('• User management (Admin)'),
          ],
        ),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D6B),
              ),
            ),
            SizedBox(height: 20),
            ContactInfoItem(
              icon: Icons.email,
              title: 'Email',
              value: 'support@treasury.gov.za',
            ),
            ContactInfoItem(
              icon: Icons.phone,
              title: 'Phone',
              value: '+27 12 315 5111',
            ),
            ContactInfoItem(
              icon: Icons.location_on,
              title: 'Address',
              value: '40 Church Square, Pretoria',
            ),
            ContactInfoItem(
              icon: Icons.web,
              title: 'Website',
              value: 'https://www.treasury.gov.za',
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ContactInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF2E7D6B),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              '404 - Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The page you are looking for does not exist.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}