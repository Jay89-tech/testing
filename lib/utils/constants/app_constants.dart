// lib/utils/constants/app_constants.dart
class AppConstants {
  // App Information
  static const String appName = 'Skills Audit System';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'National Treasury Skills Management System';
  
  // Organization Information
  static const String organizationName = 'National Treasury';
  static const String organizationEmail = 'support@treasury.gov.za';
  static const String organizationPhone = '+27 12 315 5111';
  static const String organizationAddress = '40 Church Square, Pretoria';
  static const String organizationWebsite = 'https://www.treasury.gov.za';

  // User Types
  static const String userTypeEmployee = 'Employee';
  static const String userTypeAdmin = 'Admin';
  static const List<String> userTypes = [userTypeEmployee, userTypeAdmin];

  // Skill Levels
  static const String skillLevelBeginner = 'Beginner';
  static const String skillLevelIntermediate = 'Intermediate';
  static const String skillLevelAdvanced = 'Advanced';
  static const String skillLevelExpert = 'Expert';

  // Skill Categories
  static const List<String> skillCategories = [
    'Technical',
    'Leadership',
    'Communication',
    'Project Management',
    'Finance',
    'Legal',
    'Administrative',
    'Language',
    'Certification',
    'Other',
  ];

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxSkillNameLength = 100;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonHeight = 48.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx', 'txt'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Keys
  static const String userDataCacheKey = 'user_data';
  static const String skillsCacheKey = 'user_skills';
  static const String departmentsCacheKey = 'departments';

  // Error Messages
  static const String genericErrorMessage = 'An error occurred. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String timeoutErrorMessage = 'Request timed out. Please try again.';
  static const String authErrorMessage = 'Authentication failed. Please sign in again.';
  static const String permissionErrorMessage = 'Permission denied. Please check your access rights.';

  // Success Messages
  static const String skillAddedMessage = 'Skill added successfully!';
  static const String skillUpdatedMessage = 'Skill updated successfully!';
  static const String skillDeletedMessage = 'Skill deleted successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String passwordResetEmailSentMessage = 'Password reset email sent!';

  // Regular Expressions
  static const String emailRegexPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String urlRegexPattern = r'^https?:\/\/[^\s/$.?#].[^\s]*$';
  static const String phoneRegexPattern = r'^(\+27|0)[6-8][0-9]{8}$';
  static const String nameRegexPattern = r"^[a-zA-Z\s\-']+$";

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  static const String monthYearFormat = 'MMM yyyy';

  // Notification Types
  static const String notificationTypeSkillExpiry = 'skill_expiry';
  static const String notificationTypeSkillUpdate = 'skill_update';
  static const String notificationTypeSystemUpdate = 'system_update';

  // Storage Paths
  static const String profileImagesPath = 'profile_images/';
  static const String skillCertificatesPath = 'skill_certificates/';
  static const String documentsPath = 'documents/';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableNotifications = true;
  static const bool enableFileUpload = true;

  // Debounce Delays
  static const Duration searchDebounceDelay = Duration(milliseconds: 300);
  static const Duration autoSaveDelay = Duration(seconds: 2);

  // Limits
  static const int maxSkillsPerUser = 100;
  static const int maxDescriptionWords = 100;
  static const int maxSearchResults = 50;

  // Default Values
  static const String defaultAvatarUrl = 'https://via.placeholder.com/150';
  static const String defaultSkillCategory = 'Other';
  static const String defaultDepartment = 'Unassigned';

  // API Endpoints (for future use)
  static const String baseApiUrl = 'https://api.treasury.gov.za/skills';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String skillsEndpoint = '/skills';
  static const String departmentsEndpoint = '/departments';
  static const String analyticsEndpoint = '/analytics';

  // Local Storage Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String lastSyncTimeKey = 'last_sync_time';
  static const String themePreferenceKey = 'theme_preference';
  static const String languagePreferenceKey = 'language_preference';
  static const String notificationSettingsKey = 'notification_settings';

  // Supported Languages
  static const String languageEnglish = 'en';
  static const String languageAfrikaans = 'af';
  static const String languageZulu = 'zu';
  static const List<String> supportedLanguages = [
    languageEnglish,
    languageAfrikaans,
    languageZulu,
  ];

  // Privacy and Terms URLs
  static const String privacyPolicyUrl = 'https://www.treasury.gov.za/privacy-policy';
  static const String termsOfServiceUrl = 'https://www.treasury.gov.za/terms-of-service';
  static const String helpUrl = 'https://www.treasury.gov.za/help';

  // Social Media Links
  static const String twitterUrl = 'https://twitter.com/SAgovnews';
  static const String facebookUrl = 'https://www.facebook.com/GovernmentZA';
  static const String linkedInUrl = 'https://www.linkedin.com/company/south-african-government';

  // Environment Configuration
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  static const bool isProduction = environment == 'production';
  static const bool isDevelopment = environment == 'development';
  static const bool isTesting = environment == 'testing';

  // Logging Configuration
  static const bool enableLogging = !isProduction;
  static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'info');
}