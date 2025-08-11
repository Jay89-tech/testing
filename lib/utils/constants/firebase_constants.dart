// lib/utils/constants/firebase_constants.dart
class FirebaseConstants {
  // Collection Names
  static const String usersCollection = 'users';
  static const String skillsCollection = 'skills';
  static const String departmentsCollection = 'departments';
  static const String analyticsCollection = 'analytics';
  static const String notificationsCollection = 'notifications';
  static const String feedbackCollection = 'feedback';
  static const String auditLogsCollection = 'audit_logs';

  // User Document Fields
  static const String userIdField = 'id';
  static const String userNameField = 'name';
  static const String userEmailField = 'email';
  static const String userDepartmentField = 'department';
  static const String userTypeField = 'userType';
  static const String userSkillsField = 'skills';
  static const String userCreatedAtField = 'createdAt';
  static const String userUpdatedAtField = 'updatedAt';
  static const String userProfileImageField = 'profileImage';
  static const String userIsActiveField = 'isActive';
  static const String userLastLoginField = 'lastLogin';

  // Skill Document Fields
  static const String skillIdField = 'id';
  static const String skillUserIdField = 'userId';
  static const String skillNameField = 'name';
  static const String skillCategoryField = 'category';
  static const String skillLevelField = 'level';
  static const String skillDescriptionField = 'description';
  static const String skillCertificationUrlField = 'certificationUrl';
  static const String skillAcquiredDateField = 'acquiredDate';
  static const String skillExpiryDateField = 'expiryDate';
  static const String skillIsVerifiedField = 'isVerified';
  static const String skillCreatedAtField = 'createdAt';
  static const String skillUpdatedAtField = 'updatedAt';
  static const String skillVerifiedByField = 'verifiedBy';
  static const String skillVerifiedDateField = 'verifiedDate';

  // Department Document Fields
  static const String departmentIdField = 'id';
  static const String departmentNameField = 'name';
  static const String departmentCodeField = 'code';
  static const String departmentDescriptionField = 'description';
  static const String departmentHeadField = 'headOfDepartment';
  static const String departmentEmployeeCountField = 'employeeCount';
  static const String departmentCreatedAtField = 'createdAt';
  static const String departmentUpdatedAtField = 'updatedAt';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String skillCertificatesPath = 'skill_certificates';
  static const String documentsPath = 'documents';
  static const String exportsPath = 'exports';

  // Query Limits
  static const int defaultQueryLimit = 20;
  static const int maxQueryLimit = 100;
  static const int skillsQueryLimit = 50;
  static const int usersQueryLimit = 100;

  // Cache Settings
  static const Duration cacheTimeout = Duration(minutes: 30);
  static const int maxCacheSize = 50;

  // Firestore Settings
  static const bool enableOfflinePersistence = true;
  static const int cacheSizeBytes = 100 * 1024 * 1024; // 100 MB

  // Security Rules Constants
  static const String adminUserType = 'Admin';
  static const String employeeUserType = 'Employee';

  // Batch Operation Limits
  static const int maxBatchWrites = 500;
  static const int maxBulkInserts = 100;

  // Indexing Fields (for composite queries)
  static const List<String> userSearchFields = [
    userNameField,
    userEmailField,
    userDepartmentField,
  ];

  static const List<String> skillSearchFields = [
    skillNameField,
    skillCategoryField,
    skillDescriptionField,
  ];

  // Validation Rules
  static const int maxUserNameLength = 100;
  static const int maxEmailLength = 254;
  static const int maxDepartmentLength = 100;
  static const int maxSkillNameLength = 100;
  static const int maxDescriptionLength = 1000;
  static const int maxUrlLength = 2048;

  // Error Messages
  static const String permissionDeniedError = 'Permission denied';
  static const String documentNotFoundError = 'Document not found';
  static const String networkErrorMessage = 'Network error occurred';
  static const String unknownErrorMessage = 'An unknown error occurred';

  // Analytics Events
  static const String skillAddedEvent = 'skill_added';
  static const String skillUpdatedEvent = 'skill_updated';
  static const String skillDeletedEvent = 'skill_deleted';
  static const String userSignInEvent = 'user_sign_in';
  static const String userSignUpEvent = 'user_sign_up';
  static const String userSignOutEvent = 'user_sign_out';
  static const String profileUpdatedEvent = 'profile_updated';

  // Notification Types
  static const String skillExpiryNotification = 'skill_expiry';
  static const String skillVerificationNotification = 'skill_verification';
  static const String systemUpdateNotification = 'system_update';
  static const String welcomeNotification = 'welcome';

  // File Upload Constraints
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];
  static const List<String> allowedDocumentTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'text/plain',
  ];

  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 30);

  // Transaction Limits
  static const Duration transactionTimeout = Duration(seconds: 30);
  static const int maxTransactionRetries = 5;
}