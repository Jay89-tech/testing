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

  SkillModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.proficiencyLevel,
    required this.experienceYears,
    this.description,
    this.certificationUrl,
    required this.acquiredDate,
    this.expiryDate,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    try {
      return SkillModel(
        id: id,
        userId: map['userId']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        category: map['category']?.toString() ?? 'Other',
        // Ensure proficiencyLevel is always a valid string
        proficiencyLevel: _validateProficiencyLevel(map['proficiencyLevel']),
        // Ensure experienceYears is always a valid string
        experienceYears: _validateExperienceYears(map['experienceYears']),
        description: map['description']?.toString(),
        certificationUrl: map['certificationUrl']?.toString(),
        acquiredDate: _parseDateTime(map['acquiredDate']) ?? DateTime.now(),
        expiryDate: _parseDateTime(map['expiryDate']),
        isVerified: map['isVerified'] == true,
        createdAt: _parseDateTime(map['createdAt']) ?? DateTime.now(),
        updatedAt: _parseDateTime(map['updatedAt']),
      );
    } catch (e) {
      print('Error parsing SkillModel from map: $e');
      print('Map data: $map');
      rethrow;
    }
  }

  // Helper method to validate proficiency level
  static String _validateProficiencyLevel(dynamic value) {
    if (value == null) return 'Beginner';
    
    final String strValue = value.toString();
    const validLevels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];
    
    // Check if the value matches any valid level (case insensitive)
    for (String level in validLevels) {
      if (strValue.toLowerCase() == level.toLowerCase()) {
        return level;
      }
    }
    
    // Default to Beginner if invalid
    return 'Beginner';
  }

  // Helper method to validate experience years
  static String _validateExperienceYears(dynamic value) {
    if (value == null) return '0';
    
    final String strValue = value.toString();
    
    // Try to parse as number to validate
    final int? years = int.tryParse(strValue);
    if (years != null && years >= 0) {
      return years.toString();
    }
    
    // Default to 0 if invalid
    return '0';
  }

  // Helper method to parse DateTime objects
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    try {
      // If it's already a DateTime, return it
      if (value is DateTime) return value;
      
      // If it's a Firestore Timestamp, convert it
      if (value.runtimeType.toString() == 'Timestamp') {
        return value.toDate();
      }
      
      // If it's a string, try to parse it
      if (value is String) {
        return DateTime.tryParse(value);
      }
      
      // If it has a toDate method, call it
      if (value.runtimeType.toString().contains('Timestamp')) {
        return value.toDate();
      }
      
      return null;
    } catch (e) {
      print('Error parsing DateTime: $e');
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'proficiencyLevel': proficiencyLevel,
      'experienceYears': experienceYears,
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
    String? proficiencyLevel,
    String? experienceYears,
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
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
      experienceYears: experienceYears ?? this.experienceYears,
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

  // Helper method to get SkillLevel enum from proficiencyLevel string
  SkillLevel get skillLevelEnum {
    return SkillLevel.fromString(proficiencyLevel);
  }

  @override
  String toString() {
    return 'SkillModel(id: $id, name: $name, category: $category, proficiencyLevel: $proficiencyLevel, experienceYears: $experienceYears, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.category == category &&
        other.proficiencyLevel == proficiencyLevel &&
        other.experienceYears == experienceYears;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        category.hashCode ^
        proficiencyLevel.hashCode ^
        experienceYears.hashCode;
  }
}