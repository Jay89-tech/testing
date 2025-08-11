// lib/controllers/base_controller.dart
import 'package:flutter/material.dart';
import 'dart:async';

abstract class BaseController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isDisposed => _disposed;

  // Set loading state
  void setLoading(bool loading) {
    if (_disposed) return;
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // Set error
  void setError(String? error) {
    if (_disposed) return;
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    setError(null);
  }

  // Execute with loading state
  Future<T?> executeWithLoading<T>(Future<T> Function() operation) async {
    if (_disposed) return null;
    
    try {
      setLoading(true);
      clearError();
      final result = await operation();
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  // Execute without loading state but with error handling
  Future<T?> executeWithErrorHandling<T>(Future<T> Function() operation) async {
    if (_disposed) return null;
    
    try {
      clearError();
      final result = await operation();
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  // Safe notify listeners
  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Show snack bar message
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: duration ?? const Duration(seconds: 4),
          action: action,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Show error snack bar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  // Show success snack bar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFF2E7D6B),
    );
  }

  // Show warning snack bar
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.orange,
    );
  }

  // Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null
                ? TextButton.styleFrom(foregroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Show error dialog
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onOk,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOk?.call();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // Handle exceptions and convert to user-friendly messages
  static String getErrorMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';
    
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network')) {
      return 'Network error. Please check your internet connection.';
    }
    
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (errorString.contains('permission')) {
      return 'Permission denied. Please check your access rights.';
    }
    
    if (errorString.contains('not found')) {
      return 'The requested resource was not found.';
    }
    
    if (errorString.contains('invalid')) {
      return 'Invalid data provided. Please check your input.';
    }
    
    // Return the original error message if it's not too technical
    final originalMessage = error.toString();
    if (originalMessage.length < 100 && !originalMessage.contains('Exception')) {
      return originalMessage;
    }
    
    return 'An error occurred. Please try again later.';
  }

  // Debounce function for search and other operations
  static void debounce(
    Duration duration,
    VoidCallback callback, {
    String? key,
  }) {
    _debounceTimers[key ?? 'default']?.cancel();
    _debounceTimers[key ?? 'default'] = Timer(duration, callback);
  }

  static final Map<String, Timer> _debounceTimers = {};
}