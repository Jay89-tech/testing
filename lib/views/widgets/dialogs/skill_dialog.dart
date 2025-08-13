// lib/views/widgets/dialogs/skill_dialog.dart
import 'package:flutter/material.dart';
import '../common/custom_text_field.dart';
import '../common/custom_button.dart';

class SkillDialog extends StatefulWidget {
  final Map<String, dynamic>? skillData;
  final bool isEditing;
  final Function(Map<String, dynamic>) onSave;

  const SkillDialog({
    super.key,
    this.skillData,
    this.isEditing = false,
    required this.onSave,
  });

  @override
  State<SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<SkillDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Technical';
  int _proficiency = 1;
  bool _hasCertification = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Technical',
    'Soft Skills',
    'Leadership',
    'Languages',
    'Certifications',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.skillData != null) {
      _loadSkillData();
    }
  }

  void _loadSkillData() {
    final data = widget.skillData!;
    _nameController.text = data['name'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _selectedCategory = data['category'] ?? 'Technical';
    _proficiency = data['proficiency'] ?? 1;
    _hasCertification = data['hasCertification'] ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Skill Name
                      CustomTextField(
                        label: 'Skill Name',
                        hintText: 'Enter skill name',
                        controller: _nameController,
                        prefixIcon: Icons.psychology,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Skill name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Category Dropdown
                      CustomDropdownField<String>(
                        label: 'Category',
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
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
                      
                      // Proficiency Level
                      _buildProficiencySelector(),
                      
                      const SizedBox(height: 16),
                      
                      // Description
                      CustomTextArea(
                        label: 'Description (Optional)',
                        hintText: 'Describe your experience with this skill...',
                        controller: _descriptionController,
                        maxLines: 3,
                        maxLength: 300,
                        showCounter: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Certification Toggle
                      _buildCertificationToggle(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Icon(
            widget.isEditing ? Icons.edit : Icons.add,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.isEditing ? 'Edit Skill' : 'Add New Skill',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildProficiencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proficiency Level',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getProficiencyText(_proficiency),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _getProficiencyColor(_proficiency),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getProficiencyColor(_proficiency).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_proficiency/5',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getProficiencyColor(_proficiency),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (index) {
                  final level = index + 1;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _proficiency = level;
                        });
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: level <= _proficiency
                              ? _getProficiencyColor(_proficiency)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            level.toString(),
                            style: TextStyle(
                              color: level <= _proficiency
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                _getProficiencyDescription(_proficiency),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            _hasCertification ? Icons.verified : Icons.verified_outlined,
            color: _hasCertification ? Colors.orange : Colors.grey[400],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Certification',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Do you have a certification for this skill?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _hasCertification,
            onChanged: (value) {
              setState(() {
                _hasCertification = value;
              });
            },
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomOutlineButton(
              text: 'Cancel',
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: widget.isEditing ? 'Update' : 'Add Skill',
              onPressed: _isLoading ? null : _saveSkill,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  void _saveSkill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final skillData = {
        if (widget.isEditing && widget.skillData != null)
          'id': widget.skillData!['id'],
        'name': _nameController.text.trim(),
        'category': _selectedCategory,
        'proficiency': _proficiency,
        'description': _descriptionController.text.trim(),
        'hasCertification': _hasCertification,
        'dateAdded': widget.isEditing 
            ? widget.skillData!['dateAdded'] 
            : DateTime.now(),
        'dateModified': DateTime.now(),
      };

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      widget.onSave(skillData);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing 
                  ? 'Skill updated successfully!' 
                  : 'Skill added successfully!',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getProficiencyColor(int proficiency) {
    switch (proficiency) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getProficiencyText(int proficiency) {
    switch (proficiency) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Basic';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Unknown';
    }
  }

  String _getProficiencyDescription(int proficiency) {
    switch (proficiency) {
      case 1:
        return 'Just starting to learn this skill';
      case 2:
        return 'Have basic knowledge and can perform simple tasks';
      case 3:
        return 'Comfortable with most aspects, can work independently';
      case 4:
        return 'Highly skilled, can handle complex tasks and guide others';
      case 5:
        return 'Expert level, can teach and innovate in this area';
      default:
        return '';
    }
  }

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    Map<String, dynamic>? skillData,
    bool isEditing = false,
    required Function(Map<String, dynamic>) onSave,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SkillDialog(
        skillData: skillData,
        isEditing: isEditing,
        onSave: onSave,
      ),
    );
  }
}

class QuickSkillDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const QuickSkillDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<QuickSkillDialog> createState() => _QuickSkillDialogState();
}

class _QuickSkillDialogState extends State<QuickSkillDialog> {
  final _nameController = TextEditingController();
  String _selectedCategory = 'Technical';
  int _proficiency = 3;
  bool _isLoading = false;

  final List<String> _categories = [
    'Technical',
    'Soft Skills',
    'Leadership',
    'Languages',
    'Certifications',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Quick Add Skill',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            CustomTextField(
              label: 'Skill Name',
              hintText: 'Enter skill name',
              controller: _nameController,
              autofocus: true,
            ),
            
            const SizedBox(height: 16),
            
            CustomDropdownField<String>(
              label: 'Category',
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
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
            
            Text(
              'Proficiency: ${_getProficiencyText(_proficiency)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _proficiency.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _proficiency = value.round();
                });
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: CustomOutlineButton(
                    text: 'Cancel',
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Add',
                    onPressed: _isLoading ? null : _quickSave,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _quickSave() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a skill name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final skillData = {
        'name': _nameController.text.trim(),
        'category': _selectedCategory,
        'proficiency': _proficiency,
        'description': '',
        'hasCertification': false,
        'dateAdded': DateTime.now(),
        'dateModified': DateTime.now(),
      };

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));

      widget.onSave(skillData);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Skill added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getProficiencyText(int proficiency) {
    switch (proficiency) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Basic';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Unknown';
    }
  }

  static Future<void> show(
    BuildContext context, {
    required Function(Map<String, dynamic>) onSave,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuickSkillDialog(onSave: onSave),
    );
  }
}