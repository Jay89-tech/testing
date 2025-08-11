// lib/models/auth_result_model.dart
import 'user_model.dart';

class AuthResultModel {
  final bool success;
  final UserModel? user;
  final String message;
  final String? errorCode;

  AuthResultModel({
    required this.success,
    this.user,
    required this.message,
    this.errorCode,
  });

  factory AuthResultModel.success({
    UserModel? user,
    String? message,
  }) {
    return AuthResultModel(
      success: true,
      user: user,
      message: message ?? 'Operation successful',
    );
  }

  factory AuthResultModel.failure({
    required String message,
    String? errorCode,
  }) {
    return AuthResultModel(
      success: false,
      message: message,
      errorCode: errorCode,
    );
  }

  @override
  String toString() {
    return 'AuthResultModel(success: $success, message: $message, user: ${user?.name})';
  }
}