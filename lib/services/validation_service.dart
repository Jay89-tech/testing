// lib/services/validation_service.dart
class ValidationService {
  // Configurable error messages for easy localization
  static const String emailRequiredMsg = 'Email is required';
  static const String invalidEmailMsg = 'Invalid email address';
  static const String passwordRequiredMsg = 'Password is required';
  static const String passwordMin6Msg = 'Password must be at least 6 characters long';
  static const String passwordRecommended8Msg = 'For better security, use at least 8 characters';
  static const String passwordUppercaseMsg = 'Include at least one uppercase letter';
  static const String passwordLowercaseMsg = 'Include at least one lowercase letter';
  static const String passwordDigitMsg = 'Include at least one number';
  static const String passwordSpecialCharMsg = 'Include at least one special character';
  static const String usernameRequiredMsg = 'Username is required';
  static const String usernameLengthMsg = 'Username must be between 3 and 20 characters';
  static const String usernameCharsMsg = 'Username can only contain letters, numbers, underscores, and periods';
  static const String phoneRequiredMsg = 'Phone number is required';
  static const String phoneInvalidMsg = 'Invalid phone number format';

  // Email validation
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    return emailRegex.hasMatch(email.trim());
  }

  // Password validation with strength check
  static Map<String, dynamic> validatePassword(String password) {
    final result = <String, dynamic>{
      'isValid': false,
      'errors': <String>[],
      'strength': 'Weak',
    };

    if (password.isEmpty) {
      (result['errors'] as List<String>).add(passwordRequiredMsg);
      return result;
    }

    if (password.length < 6) {
      (result['errors'] as List<String>).add(passwordMin6Msg);
    } else if (password.length < 8) {
      (result['errors'] as List<String>).add(passwordRecommended8Msg);
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      (result['errors'] as List<String>).add(passwordUppercaseMsg);
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      (result['errors'] as List<String>).add(passwordLowercaseMsg);
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      (result['errors'] as List<String>).add(passwordDigitMsg);
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      (result['errors'] as List<String>).add(passwordSpecialCharMsg);
    }

    // Strength evaluation
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score >= 5) {
      result['strength'] = 'Strong';
    } else if (score >= 3) {
      result['strength'] = 'Medium';
    }

    result['isValid'] = (result['errors'] as List<String>).isEmpty;
    return result;
  }

  // Username validation
  static Map<String, dynamic> validateUsername(String username) {
    final result = <String, dynamic>{
      'isValid': false,
      'errors': <String>[],
    };

    if (username.trim().isEmpty) {
      (result['errors'] as List<String>).add(usernameRequiredMsg);
    } else {
      if (username.length < 3 || username.length > 20) {
        (result['errors'] as List<String>).add(usernameLengthMsg);
      }
      if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(username)) {
        (result['errors'] as List<String>).add(usernameCharsMsg);
      }
    }

    result['isValid'] = (result['errors'] as List<String>).isEmpty;
    return result;
  }

  // Phone number validation (basic international format)
  static Map<String, dynamic> validatePhoneNumber(String phone) {
    final result = <String, dynamic>{
      'isValid': false,
      'errors': <String>[],
    };

    if (phone.trim().isEmpty) {
      (result['errors'] as List<String>).add(phoneRequiredMsg);
    } else {
      final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
      if (!phoneRegex.hasMatch(phone.trim())) {
        (result['errors'] as List<String>).add(phoneInvalidMsg);
      }
    }

    result['isValid'] = (result['errors'] as List<String>).isEmpty;
    return result;
  }
}