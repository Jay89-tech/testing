// lib/utils/routes.dart
import 'package:flutter/material.dart';
import '../views/screens/splash_screen.dart';
import '../views/screens/auth_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/profile_screen.dart';
import '../views/screens/skills/skills_list_screen.dart';
import '../views/screens/skills/add_skill_screen.dart';

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

      /*case editSkill:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddSkillScreen(
            skillData: args?['skillData'],
            isEditing: true,
          ),
          settings: settings,
        );*/

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
          builder: (_) => const ComingSoonScreen(title: 'Analytics'),
          settings: settings,
        );

      case userManagement:
        return MaterialPageRoute(
          builder: (_) => const ComingSoonScreen(title: 'User Management'),
          settings: settings,
        );

     /* case settings:
        return MaterialPageRoute(
          builder: (_) => const ComingSoonScreen(title: 'Settings'),
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

// Placeholder screens for routes that don't exist yet
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