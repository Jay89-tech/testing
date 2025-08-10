
// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/../views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SkillsAuditApp());
}

class SkillsAuditApp extends StatelessWidget {
  const SkillsAuditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skills Audit System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2E7D6B),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D6B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D6B),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D6B), width: 2),
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}





// Create these files in your Flutter project:

// android/app/google-services.json
// (Download from Firebase Console after setting up your project)

// ios/Runner/GoogleService-Info.plist
// (Download from Firebase Console after setting up your project)

// firebase_options.dart
// (Generate using `flutterfire configure` command)