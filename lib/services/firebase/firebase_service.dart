// lib/services/firebase/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
      _initialized = true;
      print('Firebase initialized successfully');

      // Enable Firestore offline persistence (new API)
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );

    } catch (e) {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }

  static bool get isInitialized => _initialized;

  // Test connection to Firebase
  static Future<bool> testConnection() async {
    try {
      await FirebaseFirestore.instance
          .collection('test')
          .limit(1)
          .get(const GetOptions(source: Source.server));
      return true;
    } catch (e) {
      print('Firebase connection test failed: $e');
      return false;
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Sign out
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Check if user is authenticated
  static bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser != null;
  }
}
