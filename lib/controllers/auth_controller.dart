// lib/controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';
import '../services/firebase/auth_service.dart';
import '../services/firebase/firestore_service.dart';

class AuthController {
  static User? get currentUser => AuthService.getCurrentUser();
  static bool get isAuthenticated => AuthService.isAuthenticated;
  static Stream<User?> get authStateChanges => AuthService.authStateChanges;

  // Sign in with email and password
  static Future<AuthResultModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty || password.isEmpty) {
        return AuthResultModel.failure(
          message: 'Please enter both email and password',
        );
      }

      return await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return AuthResultModel.failure(
        message: 'Sign in failed: ${e.toString()}',
      );
    }
  }

  // Create new user account
  static Future<AuthResultModel> signUp({
    required String email,
    required String password,
    required String name,
    required String department,
    required String userType,
  }) async {
    try {
      if (email.trim().isEmpty || 
          password.isEmpty || 
          name.trim().isEmpty || 
          department.trim().isEmpty) {
        return AuthResultModel.failure(
          message: 'Please fill in all required fields',
        );
      }

      return await AuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        department: department,
        userType: userType,
      );
    } catch (e) {
      return AuthResultModel.failure(
        message: 'Sign up failed: ${e.toString()}',
      );
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await AuthService.signOut();
    } catch (e) {
      print('Sign out error: $e');
      // Still try to sign out even if there's an error
      rethrow;
    }
  }

  // Get current user data from Firestore
  static Future<UserModel?> getCurrentUserData() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      return await FirestoreService.getUser(user.uid);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  static Future<AuthResultModel> updateProfile({
    required String name,
    required String department,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return AuthResultModel.failure(
          message: 'No authenticated user found',
        );
      }

      final currentUserData = await FirestoreService.getUser(user.uid);
      if (currentUserData == null) {
        return AuthResultModel.failure(
          message: 'User data not found',
        );
      }

      final updatedUser = currentUserData.copyWith(
        name: name.trim(),
        department: department.trim(),
        updatedAt: DateTime.now(),
      );

      await FirestoreService.updateUser(updatedUser);

      return AuthResultModel.success(
        user: updatedUser,
        message: 'Profile updated successfully',
      );
    } catch (e) {
      return AuthResultModel.failure(
        message: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  // Send password reset email
  static Future<AuthResultModel> sendPasswordResetEmail(String email) async {
    try {
      if (email.trim().isEmpty) {
        return AuthResultModel.failure(
          message: 'Please enter your email address',
        );
      }

      return await AuthService.sendPasswordResetEmail(email);
    } catch (e) {
      return AuthResultModel.failure(
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  // Update password
  static Future<AuthResultModel> updatePassword(String newPassword) async {
    try {
      if (newPassword.length < 6) {
        return AuthResultModel.failure(
          message: 'Password must be at least 6 characters long',
        );
      }

      return await AuthService.updatePassword(newPassword);
    } catch (e) {
      return AuthResultModel.failure(
        message: 'Failed to update password: ${e.toString()}',
      );
    }
  }

  // Delete account
  static Future<AuthResultModel> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        return AuthResultModel.failure(
          message: 'No authenticated user found',
        );
      }

      return await AuthService.deleteAccount();
    } catch (e) {
      return AuthResultModel.failure(
        message: 'Failed to delete account: ${e.toString()}',
      );
    }
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    try {
      final userData = await getCurrentUserData();
      return userData?.userType == 'Admin';
    } catch (e) {
      return false;
    }
  }

  // Check if user exists in Firestore
  static Future<bool> userExistsInFirestore() async {
    try {
      final user = currentUser;
      if (user == null) return false;

      return await FirestoreService.userExists(user.uid);
    } catch (e) {
      return false;
    }
  }

  // Refresh user token
  static Future<void> refreshUserToken() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.getIdToken(true);
      }
    } catch (e) {
      print('Error refreshing user token: $e');
    }
  }
}