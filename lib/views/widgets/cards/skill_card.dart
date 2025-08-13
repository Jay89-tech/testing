// lib/views/widgets/cards/skill_card.dart
import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final Map<String, dynamic> skillData;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool isCompact;

  const SkillCard({
    super.key,
    required this.skillData,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final skillName = skillData['name'] ?? 'Unknown Skill';
    final category = skillData['category'] ?? 'General';
    final proficiency = skillData['proficiency'] ?? 1;
    final description = skillData['description'] ?? '';
    final dateAdded = skillData['dateAdded'] as DateTime?;
    final hasCertification = skillData['hasCertification'] ?? false;

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skillName,
                          style: TextStyle(
                            fontSize: isCompact ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(category).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getCategoryColor(category),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (hasCertification) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showActions)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
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
              ),
              
              if (!isCompact) ...[
                const SizedBox(height: 12),
                
                // Proficiency Level
                Row(
                  children: [
                    Text(
                      'Proficiency: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: _buildProficiencyBar(proficiency),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getProficiencyText(proficiency),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getProficiencyColor(proficiency),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                if (dateAdded != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Added ${_formatDate(dateAdded)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ] else ...[
                const SizedBox(height: 8),
                _buildCompactProficiencyBar(proficiency),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProficiencyBar(int proficiency) {
    return Row(
      children: List.generate(5, (index) {
        return Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: index < proficiency
                  ? _getProficiencyColor(proficiency)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCompactProficiencyBar(int proficiency) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: proficiency / 5.0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProficiencyColor(proficiency),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$proficiency/5',
          style: TextStyle(
            fontSize: 12,
            color: _getProficiencyColor(proficiency),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technical':
        return Colors.blue;
      case 'soft skills':
        return Colors.green;
      case 'leadership':
        return Colors.purple;
      case 'languages':
        return Colors.orange;
      case 'certifications':
        return Colors.red;
      default:
        return const Color(0xFF2E7D6B);
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}

class SkillSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> skills;
  final VoidCallback? onViewAll;

  const SkillSummaryCard({
    super.key,
    required this.skills,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final totalSkills = skills.length;
    final avgProficiency = totalSkills > 0
        ? skills.map((s) => s['proficiency'] as int).reduce((a, b) => a + b) / totalSkills
        : 0.0;
    final certifiedSkills = skills.where((s) => s['hasCertification'] == true).length;

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
                  'Skills Overview',
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
                    'Total Skills',
                    totalSkills.toString(),
                    Icons.psychology,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Avg. Proficiency',
                    avgProficiency.toStringAsFixed(1),
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Certified',
                    certifiedSkills.toString(),
                    Icons.verified,
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