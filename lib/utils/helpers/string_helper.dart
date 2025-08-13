
// lib/utils/helpers/string_helper.dart
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class StringHelper {
  // Check if string is null or empty
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  // Check if string is null, empty, or whitespace
  static bool isNullOrWhitespace(String? value) {
    return value == null || value.trim().isEmpty;
  }

  // Capitalize first letter
  static String capitalize(String value) {
    if (isNullOrEmpty(value)) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  // Capitalize first letter of each word
  static String capitalizeWords(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Convert to title case
  static String toTitleCase(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  // Convert camelCase to title case
  static String camelCaseToTitle(String value) {
    if (isNullOrEmpty(value)) return value;
    return value
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim()
        .split(' ')
        .map((word) => capitalize(word))
        .join(' ');
  }

  // Convert to snake_case
  static String toSnakeCase(String value) {
    if (isNullOrEmpty(value)) return value;
    return value
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => '_${match.group(1)}')
        .toLowerCase()
        .replaceFirst(RegExp(r'^_'), '');
  }

  // Convert to kebab-case
  static String toKebabCase(String value) {
    if (isNullOrEmpty(value)) return value;
    return value
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => '-${match.group(1)}')
        .toLowerCase()
        .replaceFirst(RegExp(r'^-'), '');
  }

  // Convert to camelCase
  static String toCamelCase(String value) {
    if (isNullOrEmpty(value)) return value;
    List<String> words = value.split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return value;
    
    String result = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      result += capitalize(words[i]);
    }
    return result;
  }

  // Truncate string with ellipsis
  static String truncate(String value, int maxLength, {String suffix = '...'}) {
    if (isNullOrEmpty(value) || value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}$suffix';
  }

  // Truncate string by words
  static String truncateWords(String value, int maxWords, {String suffix = '...'}) {
    if (isNullOrEmpty(value)) return value;
    List<String> words = value.split(' ');
    if (words.length <= maxWords) return value;
    return '${words.take(maxWords).join(' ')}$suffix';
  }

  // Remove extra whitespace
  static String cleanWhitespace(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Remove all whitespace
  static String removeWhitespace(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'\s'), '');
  }

  // Validate email
  static bool isValidEmail(String email) {
    if (isNullOrEmpty(email)) return false;
    return RegExp(AppConstants.emailRegexPattern).hasMatch(email);
  }

  // Validate URL
  static bool isValidUrl(String url) {
    if (isNullOrEmpty(url)) return false;
    return RegExp(AppConstants.urlRegexPattern).hasMatch(url);
  }

  // Validate phone number (South African format)
  static bool isValidPhoneNumber(String phone) {
    if (isNullOrEmpty(phone)) return false;
    return RegExp(AppConstants.phoneRegexPattern).hasMatch(phone);
  }

  // Validate name (letters, spaces, hyphens, apostrophes only)
  static bool isValidName(String name) {
    if (isNullOrEmpty(name)) return false;
    return RegExp(AppConstants.nameRegexPattern).hasMatch(name);
  }

  // Extract initials from name
  static String getInitials(String name, {int maxInitials = 2}) {
    if (isNullOrEmpty(name)) return '';
    List<String> words = name.trim().split(' ');
    String initials = '';
    
    for (int i = 0; i < words.length && i < maxInitials; i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }
    
    return initials;
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String result = '';
    
    for (int i = 0; i < length; i++) {
      result += chars[(random + i) % chars.length];
    }
    
    return result;
  }

  // Count words in string
  static int countWords(String value) {
    if (isNullOrEmpty(value)) return 0;
    return value.trim().split(RegExp(r'\s+')).length;
  }

  // Count characters excluding whitespace
  static int countCharacters(String value, {bool includeSpaces = true}) {
    if (isNullOrEmpty(value)) return 0;
    return includeSpaces ? value.length : removeWhitespace(value).length;
  }

  // Reverse string
  static String reverse(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.split('').reversed.join('');
  }

  // Check if string is palindrome
  static bool isPalindrome(String value) {
    if (isNullOrEmpty(value)) return false;
    String cleaned = removeWhitespace(value.toLowerCase());
    return cleaned == reverse(cleaned);
  }

  // Remove special characters
  static String removeSpecialCharacters(String value, {String replacement = ''}) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), replacement);
  }

  // Keep only letters and numbers
  static String keepAlphaNumeric(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  // Keep only numbers
  static String keepNumeric(String value) {
    if (isNullOrEmpty(value)) return value;
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
