// lib/models/department_model.dart
class DepartmentModel {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String? headOfDepartment;
  final int employeeCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.headOfDepartment,
    this.employeeCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> map, String id) {
    return DepartmentModel(
      id: id,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      description: map['description'],
      headOfDepartment: map['headOfDepartment'],
      employeeCount: map['employeeCount'] ?? 0,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'headOfDepartment': headOfDepartment,
      'employeeCount': employeeCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  DepartmentModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? headOfDepartment,
    int? employeeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      headOfDepartment: headOfDepartment ?? this.headOfDepartment,
      employeeCount: employeeCount ?? this.employeeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DepartmentModel(id: $id, name: $name, code: $code, employeeCount: $employeeCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DepartmentModel &&
        other.id == id &&
        other.name == name &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode;
  }
}

// Predefined departments for National Treasury
class DefaultDepartments {
  static const List<Map<String, String>> departments = [
    {'name': 'Budget Office', 'code': 'BO'},
    {'name': 'Financial Management', 'code': 'FM'},
    {'name': 'Public Finance', 'code': 'PF'},
    {'name': 'Intergovernmental Relations', 'code': 'IGR'},
    {'name': 'Economic Policy', 'code': 'EP'},
    {'name': 'Asset and Liability Management', 'code': 'ALM'},
    {'name': 'Government Technical Advisory Centre', 'code': 'GTAC'},
    {'name': 'Chief Financial Officer', 'code': 'CFO'},
    {'name': 'Internal Audit', 'code': 'IA'},
    {'name': 'Human Resources', 'code': 'HR'},
    {'name': 'Information Technology', 'code': 'IT'},
    {'name': 'Communications', 'code': 'COMM'},
    {'name': 'Legal Services', 'code': 'LS'},
    {'name': 'Supply Chain Management', 'code': 'SCM'},
    {'name': 'Office of the Director-General', 'code': 'DG'},
  ];
}