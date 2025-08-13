// lib/views/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_screen.dart';
import 'skills/skills_list_screen.dart';
import 'skills/add_skill_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerSlideAnimation;
  
  String _userName = '';
  String _userType = '';
  String _department = '';
  bool _isDrawerOpen = false;
  bool _isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _drawerSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists && mounted) {
          final data = doc.data()!;
          setState(() {
            _userName = data['name'] ?? 'User';
            _userType = data['userType'] ?? 'Employee';
            _department = data['department'] ?? '';
            _isLoadingUserData = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _userName = 'User';
          _userType = 'Employee';
          _department = '';
          _isLoadingUserData = false;
        });
      }
    }
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
    
    if (_isDrawerOpen) {
      _drawerAnimationController.forward();
    } else {
      _drawerAnimationController.reverse();
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _navigateToAddSkill() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddSkillScreen(),
      ),
    );
  }

  void _navigateToViewSkills() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SkillsListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Skills Audit System'),
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _drawerAnimationController,
            color: Colors.white,
          ),
          onPressed: _toggleDrawer,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: _isLoadingUserData
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D6B), Color(0xFF4A9B8E)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLoadingUserData ? 'Welcome!' : 'Welcome, $_userName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLoadingUserData ? 'Loading...' : '$_userType • $_department',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Quick actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D6B),
                  ),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildActionCard(
                        icon: Icons.add_circle,
                        title: 'Add Skills',
                        subtitle: 'Update your skill set',
                        color: const Color(0xFF4CAF50),
                        onTap: _navigateToAddSkill,
                      ),
                      _buildActionCard(
                        icon: Icons.list_alt,
                        title: 'View Skills',
                        subtitle: 'See your current skills',
                        color: const Color(0xFF2196F3),
                        onTap: _navigateToViewSkills,
                      ),
                      if (_userType == 'Admin') ...[
                        _buildActionCard(
                          icon: Icons.analytics,
                          title: 'Analytics',
                          subtitle: 'View department insights',
                          color: const Color(0xFF9C27B0),
                          onTap: () {
                            _showComingSoonDialog('Analytics');
                          },
                        ),
                        _buildActionCard(
                          icon: Icons.people,
                          title: 'Manage Users',
                          subtitle: 'View all employees',
                          color: const Color(0xFFFF9800),
                          onTap: () {
                            _showComingSoonDialog('User Management');
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Custom sliding drawer
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          
          SlideTransition(
            position: _drawerSlideAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drawer header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E7D6B), Color(0xFF4A9B8E)],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Color(0xFF2E7D6B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isLoadingUserData ? 'Loading...' : _userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _isLoadingUserData ? '' : _userType,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Drawer items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildDrawerItem(
                          icon: Icons.home,
                          title: 'Home',
                          onTap: _toggleDrawer,
                        ),
                        _buildDrawerItem(
                          icon: Icons.person,
                          title: 'Profile',
                          onTap: () {
                            _toggleDrawer();
                            _showComingSoonDialog('Profile');
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.psychology,
                          title: 'My Skills',
                          onTap: () {
                            _toggleDrawer();
                            _navigateToViewSkills();
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.add_circle_outline,
                          title: 'Add Skill',
                          onTap: () {
                            _toggleDrawer();
                            _navigateToAddSkill();
                          },
                        ),
                        if (_userType == 'Admin') ...[
                          const Divider(),
                          _buildDrawerItem(
                            icon: Icons.analytics,
                            title: 'Analytics',
                            onTap: () {
                              _toggleDrawer();
                              _showComingSoonDialog('Analytics');
                            },
                          ),
                          _buildDrawerItem(
                            icon: Icons.people,
                            title: 'User Management',
                            onTap: () {
                              _toggleDrawer();
                              _showComingSoonDialog('User Management');
                            },
                          ),
                        ],
                        const Divider(),
                        _buildDrawerItem(
                          icon: Icons.info,
                          title: 'About Us',
                          onTap: () {
                            _toggleDrawer();
                            _showAboutDialog();
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.contact_mail,
                          title: 'Contact Us',
                          onTap: () {
                            _toggleDrawer();
                            _showContactDialog();
                          },
                        ),
                        const Divider(),
                        _buildDrawerItem(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          onTap: _signOut,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D6B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF2E7D6B),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Coming Soon'),
        content: Text('The $feature feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Skills Audit System'),
        content: const Text(
          'The Skills Audit System is designed to help the National Treasury track and manage employee skills effectively. This digital solution replaces outdated manual systems with a modern, centralized platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@treasury.gov.za'),
            SizedBox(height: 8),
            Text('Phone: +27 (0) 51 507 3911'),
            SizedBox(height: 8),
            Text('Address: 20 President Brand St, Bloemfontein Central, Bloemfontein, 9301'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}