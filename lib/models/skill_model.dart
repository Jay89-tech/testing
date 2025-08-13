// lib/models/skill_model.dart
enum SkillLevel {
  beginner,
  intermediate,
  advanced,
  expert;

  String get displayName {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.advanced:
        return 'Advanced';
      case SkillLevel.expert:
        return 'Expert';
    }
  }

  static SkillLevel fromString(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return SkillLevel.beginner;
      case 'intermediate':
        return SkillLevel.intermediate;
      case 'advanced':
        return SkillLevel.advanced;
      case 'expert':
        return SkillLevel.expert;
      default:
        return SkillLevel.beginner;
    }
  }
}

class SkillModel {
  final String id;
  final String userId;
  final String name;
  final String category;
  
  // Changed to String to align with UI and controller usage
  final String proficiencyLevel;
  final String experienceYears; // Changed to String
  final String? description;
  final String? certificationUrl;
  final DateTime acquiredDate;
  final DateTime? expiryDate;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? level;

  SkillModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.proficiencyLevel, // Updated
    required this.experienceYears, // Updated
    this.description,
    this.certificationUrl,
    required this.acquiredDate,
    this.expiryDate,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.level,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    return SkillModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      // Directly use proficiencyLevel from map
      proficiencyLevel: map['proficiencyLevel'] ?? 'Beginner',
      experienceYears: map['experienceYears'] ?? '0', // Ensure it's a string
      description: map['description'],
      certificationUrl: map['certificationUrl'],
      acquiredDate: map['acquiredDate']?.toDate() ?? DateTime.now(),
      expiryDate: map['expiryDate']?.toDate(),
      isVerified: map['isVerified'] ?? false,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'proficiencyLevel': proficiencyLevel, // Updated
      'experienceYears': experienceYears, // Updated
      'description': description,
      'certificationUrl': certificationUrl,
      'acquiredDate': acquiredDate,
      'expiryDate': expiryDate,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  SkillModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? proficiencyLevel, // Updated
    String? experienceYears, // Updated
    String? description,
    String? certificationUrl,
    DateTime? acquiredDate,
    DateTime? expiryDate,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SkillModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel, // Updated
      experienceYears: experienceYears ?? this.experienceYears, // Updated
      description: description ?? this.description,
      certificationUrl: certificationUrl ?? this.certificationUrl,
      acquiredDate: acquiredDate ?? this.acquiredDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  @override
  String toString() {
    return 'SkillModel(id: $id, name: $name, category: $category, proficiencyLevel: $proficiencyLevel, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.category == category &&
        other.proficiencyLevel == proficiencyLevel; // Updated
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        category.hashCode ^
        proficiencyLevel.hashCode; // Updated
  }
}
