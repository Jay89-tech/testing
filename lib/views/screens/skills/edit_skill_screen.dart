import 'package:flutter/material.dart';
import '../../../models/skill_model.dart';
import '../../../services/firebase/firestore_service.dart';

class EditSkillScreen extends StatefulWidget {
  final SkillModel skill;

  const EditSkillScreen({
    super.key,
    required this.skill,
  });

  @override
  State<EditSkillScreen> createState() => _EditSkillScreenState();
}

class _EditSkillScreenState extends State<EditSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _certificationUrlController;
  late final TextEditingController _experienceYearsController; // Added controller for experience years

  bool _isLoading = false;
  bool _isDeleting = false;
  late String _selectedCategory;
  // Changed from SkillLevel to String to match SkillModel's proficiencyLevel
  late String _selectedProficiencyLevel;
  late DateTime _acquiredDate;
  DateTime? _expiryDate;
  late bool _hasExpiry;

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill.name);
    _descriptionController = TextEditingController(text: widget.skill.description ?? '');
    _certificationUrlController = TextEditingController(text: widget.skill.certificationUrl ?? '');
    _experienceYearsController = TextEditingController(text: widget.skill.experienceYears); // Initialize experience years
    _selectedCategory = widget.skill.category;
    // Initialize with proficiencyLevel from the skill model
    _selectedProficiencyLevel = widget.skill.proficiencyLevel;
    _acquiredDate = widget.skill.acquiredDate;
    _expiryDate = widget.skill.expiryDate;
    _hasExpiry = widget.skill.expiryDate != null;
  }

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

  Future<void> _updateSkill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedSkill = widget.skill.copyWith(
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
        updatedAt: DateTime.now(),
      );

      await FirestoreService.updateSkill(updatedSkill);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Skill updated successfully!'),
            backgroundColor: Color(0xFF2E7D6B),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to update skill: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSkill() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Skill'),
        content: Text('Are you sure you want to delete "${widget.skill.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      await FirestoreService.deleteSkill(widget.skill.id);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Skill deleted successfully!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to delete skill: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isDeleting = false);
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

  Color _getLevelColor(SkillLevel level) {
    switch (level) {
      case SkillLevel.beginner:
        return Colors.red; // Corrected to be consistent with AddSkillScreen
      case SkillLevel.intermediate:
        return Colors.orange;
      case SkillLevel.advanced:
        return Colors.blue;
      case SkillLevel.expert:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Skill'),
        actions: [
          if (!_isLoading && !_isDeleting)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteSkill();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          if (!_isLoading && !_isDeleting)
            TextButton(
              onPressed: _updateSkill,
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
      body: (_isLoading || _isDeleting)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _isDeleting ? 'Deleting skill...' : 'Updating skill...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.skill.isExpired || widget.skill.isExpiringSoon)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: widget.skill.isExpired ? Colors.red[50] : Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.skill.isExpired ? Colors.red : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.skill.isExpired ? Icons.error : Icons.warning,
                              color: widget.skill.isExpired ? Colors.red : Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.skill.isExpired ? 'Skill Expired' : 'Skill Expiring Soon',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: widget.skill.isExpired ? Colors.red[700] : Colors.orange[700],
                                    ),
                                  ),
                                  if (widget.skill.expiryDate != null)
                                    Text(
                                      'Expiry Date: ${widget.skill.expiryDate!.day}/${widget.skill.expiryDate!.month}/${widget.skill.expiryDate!.year}',
                                      style: TextStyle(
                                        color: widget.skill.isExpired ? Colors.red[600] : Colors.orange[600],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Skill Name *',
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
                        onPressed: _isLoading ? null : _updateSkill,
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
                                'Save Changes', // Changed button text
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
}
