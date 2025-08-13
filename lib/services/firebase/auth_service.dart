// lib/services/firebase/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/auth_result_model.dart';
import '../../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Sign in with email and password
  static Future<AuthResultModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (userCredential.user != null) {
        // Check if user data exists in Firestore
        final userData = await FirestoreService.getUser(userCredential.user!.uid);
        
        return AuthResultModel(
          success: true,
          user: userData,
          message: 'Sign in successful',
        );
      } else {
        return AuthResultModel(
          success: false,
          message: 'Sign in failed - no user returned',
        );
      }
    } on FirebaseAuthException catch (e) {
      return AuthResultModel(
        success: false,
        message: _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResultModel(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
  
  // Create user with email and password
  static Future<AuthResultModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String department,
    required String userType,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (userCredential.user != null) {
        // Create user document in Firestore
        final newUser = UserModel(
          id: userCredential.user!.uid,
          name: name.trim(),
          email: email.trim(),
          department: department.trim(),
          userType: userType,
          skills: [],
          createdAt: DateTime.now(),
        );
        
        await FirestoreService.addUser(newUser);
        
        return AuthResultModel(
          success: true,
          user: newUser,
          message: 'Account created successfully',
        );
      } else {
        return AuthResultModel(
          success: false,
          message: 'Account creation failed',
        );
      }
    } on FirebaseAuthException catch (e) {
      return AuthResultModel(
        success: false,
        message: _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResultModel(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  // Check if user is authenticated
  static bool get isAuthenticated {
    return _auth.currentUser != null;
  }
  
  // Listen to auth state changes
  static Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
  
  // Send password reset email
  static Future<AuthResultModel> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResultModel(
        success: true,
        message: 'Password reset email sent',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResultModel(
        success: false,
        message: _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResultModel(
        success: false,
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }
  
  // Update user password
  static Future<AuthResultModel> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResultModel(
          success: false,
          message: 'No authenticated user found',
        );
      }
      
      await user.updatePassword(newPassword);
      return AuthResultModel(
        success: true,
        message: 'Password updated successfully',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResultModel(
        success: false,
        message: _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResultModel(
        success: false,
        message: 'Failed to update password: ${e.toString()}',
      );
    }
  }
  
  // Delete user account
  static Future<AuthResultModel> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResultModel(
          success: false,
          message: 'No authenticated user found',
        );
      }
      
      // Delete user data from Firestore first
      await FirestoreService.deleteUser(user.uid);
      
      // Delete the authentication account
      await user.delete();
      
      return AuthResultModel(
        success: true,
        message: 'Account deleted successfully',
      );
    } on FirebaseAuthException catch (e) {
      return AuthResultModel(
        success: false,
        message: _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResultModel(
        success: false,
        message: 'Failed to delete account: ${e.toString()}',
      );
    }
  }
  
  // Convert Firebase Auth error codes to user-friendly messages
  static String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'requires-recent-login':
        return 'Please sign out and sign in again to perform this action.';
      case 'invalid-credential':
        return 'The provided credentials are invalid.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'timeout':
        return 'Request timed out. Please try again.';
      default:
        return 'Authentication error: $code';
    }
  }
}