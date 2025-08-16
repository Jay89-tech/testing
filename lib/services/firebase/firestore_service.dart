// lib/services/firebase/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/skill_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _usersCollection = 'users';
  static const String _skillsCollection = 'skills';
  static const String _departmentsCollection = 'departments';

  // User operations
  static Future<void> addUser(UserModel user) async {
    try {
      // Use the user's UID as the document ID
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  static Future<UserModel?> getUser(String userId) async {
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();

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
      // Debug: Print current user and document ID
      final currentUser = FirebaseAuth.instance.currentUser;
      print('Current authenticated user: ${currentUser?.uid}');
      print('Trying to update user document: ${user.id}');
      print('User data: ${user.toMap()}');

      // Ensure user is authenticated
      if (currentUser == null) {
        throw Exception('User must be authenticated to update profile');
      }

      // Ensure user can only update their own document
      if (currentUser.uid != user.id) {
        throw Exception('Cannot update other users\' profiles');
      }

      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toMap());

      print('User update successful');
    } catch (e) {
      print('Update user error: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot =
          await _firestore.collection(_usersCollection).orderBy('name').get();

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
      // Ensure the skill belongs to the current authenticated user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated to add skills');
      }
      if (skill.userId != currentUser.uid) {
        throw Exception('Cannot create skills for other users');
      }

      final docRef =
          await _firestore.collection(_skillsCollection).add(skill.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add skill: $e');
    }
  }

  static Future<void> updateSkill(SkillModel skill) async {
    try {
      // Security check - ensure user can only update their own skills
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated to update skills');
      }
      if (skill.userId != currentUser.uid) {
        throw Exception('Cannot update other users\' skills');
      }

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
      // Security check - ensure user can only delete their own skills
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated to delete skills');
      }

      // First get the skill to verify ownership
      final skillDoc =
          await _firestore.collection(_skillsCollection).doc(skillId).get();

      if (!skillDoc.exists) {
        throw Exception('Skill not found');
      }

      final skill = SkillModel.fromMap(skillDoc.data()!, skillDoc.id);
      if (skill.userId != currentUser.uid) {
        throw Exception('Cannot delete other users\' skills');
      }

      await _firestore.collection(_skillsCollection).doc(skillId).delete();
    } catch (e) {
      throw Exception('Failed to delete skill: $e');
    }
  }

  // FIXED: Updated getUserSkills method with better error handling and simplified query
  static Future<List<SkillModel>> getUserSkills(String userId) async {
    try {
      print('Getting skills for user: $userId');

      final snapshot = await _firestore
          .collection(_skillsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      print('Found ${snapshot.docs.length} skills');

      final skills = snapshot.docs
          .map((doc) {
            try {
              return SkillModel.fromMap(doc.data(), doc.id);
            } catch (e) {
              print('Error parsing skill document ${doc.id}: $e');
              return null;
            }
          })
          .where((skill) => skill != null)
          .cast<SkillModel>()
          .toList();

      // Sort by createdAt in memory to avoid index issues
      skills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return skills;
    } catch (e) {
      print('Error in getUserSkills: $e');
      throw Exception('Failed to get user skills: $e');
    }
  }

  // FIXED: Updated getUserSkillsStream with simplified query and in-memory sorting
  static Stream<List<SkillModel>> getUserSkillsStream(String userId) {
    print('Creating skills stream for user: $userId');

    return _firestore
        .collection(_skillsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      print('Stream received ${snapshot.docs.length} skills');

      final skills = snapshot.docs
          .map((doc) {
            try {
              return SkillModel.fromMap(doc.data(), doc.id);
            } catch (e) {
              print('Error parsing skill document ${doc.id}: $e');
              return null;
            }
          })
          .where((skill) => skill != null)
          .cast<SkillModel>()
          .toList();

      // Sort by createdAt in memory (newest first)
      skills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return skills;
    }).handleError((error) {
      print('Stream error: $error');
      throw Exception('Failed to stream user skills: $error');
    });
  }

  static Future<List<SkillModel>> getAllSkills() async {
    try {
      final snapshot = await _firestore.collection(_skillsCollection).get();

      final skills = snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();

      // Sort by createdAt in memory
      skills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return skills;
    } catch (e) {
      throw Exception('Failed to get all skills: $e');
    }
  }

  static Future<List<SkillModel>> getSkillsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_skillsCollection)
          .where('category', isEqualTo: category)
          .get();

      final skills = snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();

      // Sort by createdAt in memory
      skills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return skills;
    } catch (e) {
      throw Exception('Failed to get skills by category: $e');
    }
  }

  // Analytics and statistics
  static Future<Map<String, int>> getSkillsCountByCategory() async {
    try {
      final snapshot = await _firestore.collection(_skillsCollection).get();

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
      final snapshot = await _firestore.collection(_usersCollection).get();

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
      final snapshot =
          await _firestore.collection(_skillsCollection).count().get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total users count: $e');
    }
  }

  static Future<int> getTotalSkillsCount() async {
    try {
      final snapshot =
          await _firestore.collection(_skillsCollection).count().get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get total skills count: $e');
    }
  }

  // Department operations
  static Future<List<String>> getAllDepartments() async {
    try {
      final snapshot = await _firestore.collection(_usersCollection).get();

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
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();

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

  // Search operations - simplified to avoid index issues
  static Future<List<UserModel>> searchUsers(String query) async {
    try {
      // Get all users and filter in memory for now
      final snapshot = await _firestore.collection(_usersCollection).get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      users.sort((a, b) => a.name.compareTo(b.name));

      return users;
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  static Future<List<SkillModel>> searchSkills(String query) async {
    try {
      // Get all skills and filter in memory for now
      final snapshot = await _firestore.collection(_skillsCollection).get();

      final skills = snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .where(
              (skill) => skill.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      skills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return skills;
    } catch (e) {
      throw Exception('Failed to search skills: $e');
    }
  }
}
