// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String department;
  final String userType;
  final List<String> skills;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? profileImageURL;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.userType,
    required this.skills,
    required this.createdAt,
    this.updatedAt,
    this.profileImageURL,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      department: map['department'] ?? '',
      userType: map['userType'] ?? 'Employee',
      skills: List<String>.from(map['skills'] ?? []),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'department': department,
      'userType': userType,
      'skills': skills,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

UserModel copyWith({
  String? id,
  String? name,
  String? email,
  String? department,
  String? userType,
  List<String>? skills,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? profileImageURL, // Added this line
}) {
  return UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    department: department ?? this.department,
    userType: userType ?? this.userType,
    skills: skills ?? this.skills,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    profileImageURL: profileImageURL ?? this.profileImageURL, // Added this line
  );
}

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, department: $department, userType: $userType, skills: $skills)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.department == department &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        department.hashCode ^
        userType.hashCode;
  }
}