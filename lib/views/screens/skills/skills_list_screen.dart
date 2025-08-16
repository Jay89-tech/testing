// lib/views/screens/skills/skills_list_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/skill_model.dart';
import '../../../services/firebase/firestore_service.dart';
import 'add_skill_screen.dart';
import 'edit_skill_screen.dart';

class SkillsListScreen extends StatefulWidget {
  const SkillsListScreen({super.key});

  @override
  State<SkillsListScreen> createState() => _SkillsListScreenState();
}

class _SkillsListScreenState extends State<SkillsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String? _selectedProficiencyLevelFilter;

  final List<String> _categories = [
    'All',
    'Technical',
    'Leadership',
    'Communication',
    'Project Management',
    'Finance',
    'Legal',
    'Administrative',
    'Language',
    'Certification',
    'Other'
  ];

  final List<String> _proficiencyLevels = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please sign in to view your skills'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Skills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddSkill(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search skills...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Filters Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category Filter
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          underline: Container(),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Proficiency Level Filter
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: DropdownButton<String?>(
                          value: _selectedProficiencyLevelFilter,
                          hint: const Text('All Levels'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All Levels'),
                            ),
                            ..._proficiencyLevels.where((level) => level != 'All').map((level) {
                              return DropdownMenuItem<String?>(
                                value: level,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: _getLevelColorFromString(level),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(level),
                                  ],
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedProficiencyLevelFilter = value;
                            });
                          },
                          underline: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Skills List
          Expanded(
            child: StreamBuilder<List<SkillModel>>(
              stream: FirestoreService.getUserSkillsStream(user.uid),
              builder: (context, snapshot) {
                // Add more detailed error logging
                if (snapshot.hasError) {
                  print('StreamBuilder error: ${snapshot.error}');
                  print('Error details: ${snapshot.error.runtimeType}');
                  
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading skills',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Force rebuild to retry the stream
                            setState(() {});
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allSkills = snapshot.data ?? [];
                final filteredSkills = _filterSkills(allSkills);

                if (filteredSkills.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          allSkills.isEmpty ? Icons.psychology_outlined : Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          allSkills.isEmpty
                              ? 'No skills added yet'
                              : 'No skills match your search',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (allSkills.isEmpty)
                          ElevatedButton.icon(
                            onPressed: () => _navigateToAddSkill(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Your First Skill'),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSkills.length,
                  itemBuilder: (context, index) {
                    return _buildSkillCard(filteredSkills[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<SkillModel> _filterSkills(List<SkillModel> skills) {
    return skills.where((skill) {
      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          skill.name.toLowerCase().contains(_searchQuery) ||
          skill.category.toLowerCase().contains(_searchQuery) ||
          (skill.description?.toLowerCase().contains(_searchQuery) ?? false);

      // Category filter
      final matchesCategory = _selectedCategory == 'All' ||
          skill.category == _selectedCategory;

      // Proficiency level filter
      final matchesLevel = _selectedProficiencyLevelFilter == null ||
          _selectedProficiencyLevelFilter == 'All' ||
          skill.proficiencyLevel == _selectedProficiencyLevelFilter;

      return matchesSearch && matchesCategory && matchesLevel;
    }).toList();
  }

  Widget _buildSkillCard(SkillModel skill) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToEditSkill(skill),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          skill.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Experience: ${skill.experienceYears} years',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Proficiency Level indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getLevelColorFromString(skill.proficiencyLevel).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getLevelColorFromString(skill.proficiencyLevel),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getLevelColorFromString(skill.proficiencyLevel),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          skill.proficiencyLevel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getLevelColorFromString(skill.proficiencyLevel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Description
              if (skill.description != null && skill.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  skill.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Footer Row
              Row(
                children: [
                  // Acquired date
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Acquired: ${skill.acquiredDate.day}/${skill.acquiredDate.month}/${skill.acquiredDate.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  const Spacer(),

                  // Status indicators
                  if (skill.isVerified)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.green[600],
                      ),
                    ),

                  if (skill.isExpired)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: Text(
                        'Expired',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.red[700],
                        ),
                      ),
                    )
                  else if (skill.isExpiringSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange, width: 1),
                      ),
                      child: Text(
                        'Expiring Soon',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get color from proficiency level string
  Color _getLevelColorFromString(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.red;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.blue;
      case 'expert':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _navigateToAddSkill() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddSkillScreen(),
      ),
    );

    if (result == true) {
      // Skill was added successfully, list will auto-update via stream
    }
  }

  Future<void> _navigateToEditSkill(SkillModel skill) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSkillScreen(skill: skill),
      ),
    );

    if (result == true) {
      // Skill was updated/deleted, list will auto-update via stream
    }
  }
}