// lib/views/screens/skills/add_skill_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/skill_model.dart'; // Ensure this path is correct
import '../../../services/firebase/firestore_service.dart'; // Ensure this path is correct

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _certificationUrlController = TextEditingController();
  final _experienceYearsController = TextEditingController(); // Added controller for experience years

  bool _isLoading = false;
  String _selectedCategory = 'Technical';
  // Changed from SkillLevel to String to match SkillModel's proficiencyLevel
  String _selectedProficiencyLevel = SkillLevel.beginner.displayName;
  DateTime _acquiredDate = DateTime.now();
  DateTime? _expiryDate;
  bool _hasExpiry = false;

  final List<String> _skillCategories = [
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _certificationUrlController.dispose();
    _experienceYearsController.dispose(); // Dispose the new controller
    super.dispose();
  }

  Future<void> _selectAcquiredDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _acquiredDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D6B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _acquiredDate) {
      setState(() {
        _acquiredDate = picked;
      });
    }
  }

  Future<void> _selectExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D6B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _saveSkill() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showErrorDialog('User not found. Please sign in again.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final skill = SkillModel(
        id: '', // Will be set by Firestore
        userId: user.uid,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        // Pass the selected proficiency level as a String
        proficiencyLevel: _selectedProficiencyLevel,
        // Pass the experience years from the controller
        experienceYears: _experienceYearsController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        certificationUrl: _certificationUrlController.text.trim().isNotEmpty
            ? _certificationUrlController.text.trim()
            : null,
        acquiredDate: _acquiredDate,
        expiryDate: _hasExpiry ? _expiryDate : null,
        createdAt: DateTime.now(),
      );

      await FirestoreService.addSkill(skill);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Skill added successfully!'),
            backgroundColor: Color(0xFF2E7D6B),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to add skill: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Skill'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _saveSkill,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skill Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Skill Name *',
                        hintText: 'e.g., Project Management, Python Programming',
                        prefixIcon: Icon(Icons.psychology),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a skill name';
                        }
                        if (value.trim().length < 2) {
                          return 'Skill name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Certification URL
                    TextFormField(
                      controller: _certificationUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Certification URL (Optional)',
                        hintText: 'https://example.com/certificate',
                        prefixIcon: Icon(Icons.link),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final urlPattern = RegExp(
                            r'^https?:\/\/[^\s/$.?#].[^\s]*$',
                            caseSensitive: false,
                          );
                          if (!urlPattern.hasMatch(value.trim())) {
                            return 'Please enter a valid URL';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _skillCategories.map((category) {
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
                    ),
                    const SizedBox(height: 16),

                    // Proficiency Level Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedProficiencyLevel,
                      decoration: const InputDecoration(
                        labelText: 'Proficiency Level *',
                        prefixIcon: Icon(Icons.bar_chart),
                      ),
                      items: SkillLevel.values.map((level) {
                        return DropdownMenuItem(
                          value: level.displayName, // Store display name as String
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: _getLevelColor(level),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(level.displayName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProficiencyLevel = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Years of Experience
                    TextFormField(
                      controller: _experienceYearsController,
                      decoration: const InputDecoration(
                        labelText: 'Years of Experience *',
                        hintText: 'e.g., 5',
                        prefixIcon: Icon(Icons.timelapse),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter years of experience';
                        }
                        final years = int.tryParse(value.trim());
                        if (years == null || years < 0) {
                          return 'Please enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),


                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Describe your experience with this skill...',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      maxLength: 500,
                    ),
                    const SizedBox(height: 16),

                    // Acquired Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date Acquired'),
                      subtitle: Text(
                        '${_acquiredDate.day}/${_acquiredDate.month}/${_acquiredDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _selectAcquiredDate,
                    ),
                    const Divider(),

                    // Expiry Date Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Has Expiry Date'),
                      subtitle: const Text('Some certifications expire'),
                      value: _hasExpiry,
                      activeColor: const Color(0xFF2E7D6B),
                      onChanged: (value) {
                        setState(() {
                          _hasExpiry = value;
                          if (!value) {
                            _expiryDate = null;
                          }
                        });
                      },
                    ),

                    // Expiry Date (if enabled)
                    if (_hasExpiry) ...[
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event_busy),
                        title: const Text('Expiry Date'),
                        subtitle: Text(
                          _expiryDate != null
                              ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                              : 'Select expiry date',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _selectExpiryDate,
                      ),
                      const Divider(),
                    ],

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveSkill,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Add Skill',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper method to get color for SkillLevel enum
  Color _getLevelColor(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return Colors.red;
      case SkillLevel.intermediate:
        return Colors.orange;
      case SkillLevel.advanced:
        return Colors.blue;
      case SkillLevel.expert:
        return Colors.green;
    }
  }
}
