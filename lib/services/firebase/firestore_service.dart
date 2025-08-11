// lib/services/firebase/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/skill_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static const String _usersCollection = 'users';
  static const String _skillsCollection = 'skills';
  static const String _departmentsCollection = 'departments';

  // User operations
  static Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  static Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('name')
          .get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  static Future<List<UserModel>> getUsersByDepartment(String department) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('department', isEqualTo: department)
          .orderBy('name')
          .get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users by department: $e');
    }
  }

  static Stream<List<UserModel>> getUsersStream() {
    return _firestore
        .collection(_usersCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Skill operations
  static Future<String> addSkill(SkillModel skill) async {
    try {
      final docRef = await _firestore
          .collection(_skillsCollection)
          .add(skill.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }

  static Future<void> updateSkill(SkillModel skill) async {
    try {
      await _firestore
          .collection(_skillsCollection)
          .doc(skill.id)
          .update(skill.toMap());
    } catch (e) {
      throw Exception('Failed to update skill: $e');
    }
  }

  static Future<void> deleteSkill(String skillId) async {
    try {
      await _firestore
          .collection(_skillsCollection)
          .doc(skillId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete skill: $e');
    }
  }

  static Future<List<SkillModel>> getUserSkills(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user skills: $e');
    }
  }

  static Stream<List<SkillModel>> getUserSkillsStream(String userId) {
    return _firestore
        .collection(_skillsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Future<List<SkillModel>> getAllSkills() async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all skills: $e');
    }
  }

  static Future<List<SkillModel>> getSkillsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get skills by category: $e');
    }
  }

  // Analytics and statistics
  static Future<Map<String, int>> getSkillsCountByCategory() async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .get();
      
      final Map<String, int> categoryCount = {};
      
      for (final doc in snapshot.docs) {
        final category = doc.data()['category'] as String? ?? 'Other';
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
      
      return categoryCount;
    } catch (e) {
      throw Exception('Failed to get skills count by category: $e');
    }
  }

  static Future<Map<String, int>> getUsersCountByDepartment() async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .get();
      
      final Map<String, int> departmentCount = {};
      
      for (final doc in snapshot.docs) {
        final department = doc.data()['department'] as String? ?? 'Other';
        departmentCount[department] = (departmentCount[department] ?? 0) + 1;
      }
      
      return departmentCount;
    } catch (e) {
      throw Exception('Failed to get users count by department: $e');
    }
  }

  static Future<int> getTotalUsersCount() async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .count()
          .get();
      
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total users count: $e');
    }
  }

  static Future<int> getTotalSkillsCount() async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .count()
          .get();
      
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total skills count: $e');
    }
  }

  // Department operations
  static Future<List<String>> getAllDepartments() async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .get();
      
      final Set<String> departments = {};
      
      for (final doc in snapshot.docs) {
        final department = doc.data()['department'] as String?;
        if (department != null && department.isNotEmpty) {
          departments.add(department);
        }
      }
      
      final departmentList = departments.toList();
      departmentList.sort();
      return departmentList;
    } catch (e) {
      throw Exception('Failed to get all departments: $e');
    }
  }

  // Utility methods
  static Future<bool> userExists(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
      
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  static Future<void> deleteUser(String userId) async {
    try {
      // Delete user's skills first
      final skillsSnapshot = await _firestore
          .collection(_skillsCollection)
          .where('userId', isEqualTo: userId)
          .get();
      
      final batch = _firestore.batch();
      
      // Add skill deletions to batch
      for (final doc in skillsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      // Add user deletion to batch
      batch.delete(_firestore.collection(_usersCollection).doc(userId));
      
      // Execute batch
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Search operations
  static Future<List<UserModel>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  static Future<List<SkillModel>> searchSkills(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();
      
      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to search skills: $e');
    }
  }
}