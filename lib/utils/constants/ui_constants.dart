// lib/utils/constants/ui_constants.dart
import 'package:flutter/material.dart';

class UIConstants {
  // App Colors
  static const Color primaryColor = Color(0xFF2E7D6B);
  static const Color primaryDarkColor = Color(0xFF1F5A4C);
  static const Color primaryLightColor = Color(0xFF4A9B8E);
  static const Color accentColor = Color(0xFF66B8A5);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color warningColor = Color(0xFFF56500);
  static const Color successColor = Color(0xFF38A169);
  static const Color infoColor = Color(0xFF3182CE);

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF2D3748);
  static const Color textSecondaryColor = Color(0xFF718096);
  static const Color textTertiaryColor = Color(0xFFA0AEC0);
  static const Color textOnPrimaryColor = Colors.white;
  static const Color textOnSurfaceColor = Color(0xFF2D3748);

  // Skill Level Colors
  static const Color beginnerColor = Color(0xFF68D391);
  static const Color intermediateColor = Color(0xFFF6AD55);
  static const Color advancedColor = Color(0xFF63B3ED);
  static const Color expertColor = Color(0xFF9F7AEA);

  // Status Colors
  static const Color activeColor = Color(0xFF38A169);
  static const Color inactiveColor = Color(0xFFA0AEC0);
  static const Color expiredColor = Color(0xFFE53E3E);
  static const Color expiringSoonColor = Color(0xFFF56500);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border Radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXl = 16.0;
  static const double borderRadiusXxl = 20.0;
  static const double borderRadiusFull = 999.0;

  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXl = 12.0;

  // Component Heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;
  static const double listTileHeight = 56.0;

  // Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXl = 48.0;
  static const double iconSizeXxl = 64.0;

  // Font Sizes
  static const double fontSizeXs = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSizeXxl = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;
  static const double fontSizeDisplay = 32.0;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Shadows
  static const List<BoxShadow> shadowS = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> shadowM = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> shadowL = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFF7ECAB8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Input Decoration Themes
  static InputDecoration get defaultInputDecoration => InputDecoration(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
      );

  // Button Styles
  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimaryColor,
          elevation: elevationS,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          minimumSize: const Size(0, buttonHeightM),
          textStyle: const TextStyle(
            fontSize: fontSizeL,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      );

  static OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          minimumSize: const Size(0, buttonHeightM),
          textStyle: const TextStyle(
            fontSize: fontSizeL,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      );

  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeL,
            fontWeight: fontWeightMedium,
          ),
        ),
      );

  // Card Theme
  static CardTheme get cardTheme => CardTheme(
        color: surfaceColor,
        elevation: elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
        ),
        margin: const EdgeInsets.all(spacingS),
      );

  // App Bar Theme
  static AppBarTheme get appBarTheme => const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: fontSizeXl,
          fontWeight: fontWeightSemiBold,
          color: textOnPrimaryColor,
        ),
        iconTheme: IconThemeData(
          color: textOnPrimaryColor,
          size: iconSizeM,
        ),
      );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: elevationM,
      );

  // Chip Theme
  static ChipThemeData get chipTheme => ChipThemeData(
        backgroundColor: const Color(0xFFF7FAFC),
        labelStyle: const TextStyle(
          color: textPrimaryColor,
          fontSize: fontSizeS,
        ),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusXxl),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingS,
          vertical: spacingXs,
        ),
      );

  // Progress Indicator Theme
  static ProgressIndicatorThemeData get progressIndicatorTheme =>
      const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE2E8F0),
        circularTrackColor: Color(0xFFE2E8F0),
      );

  // Snack Bar Theme
  static SnackBarThemeData get snackBarTheme => SnackBarThemeData(
        backgroundColor: textPrimaryColor,
        contentTextStyle: const TextStyle(
          color: textOnPrimaryColor,
          fontSize: fontSizeM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        ),
        behavior: SnackBarBehavior.floating,

      );

  // Dialog Theme
  static DialogTheme get dialogTheme => DialogTheme(
        backgroundColor: surfaceColor,
        elevation: elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
        ),
        titleTextStyle: const TextStyle(
          fontSize: fontSizeXl,
          fontWeight: fontWeightSemiBold,
          color: textPrimaryColor,
        ),
        contentTextStyle: const TextStyle(
          fontSize: fontSizeM,
          color: textSecondaryColor,
        ),
      );

  // List Tile Theme
  static ListTileThemeData get listTileTheme => const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingXs,
        ),
        titleTextStyle: TextStyle(
          fontSize: fontSizeL,
          fontWeight: fontWeightMedium,
          color: textPrimaryColor,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: fontSizeM,
          color: textSecondaryColor,
        ),
        iconColor: textSecondaryColor,
        dense: false,
      );

  // Tab Bar Theme
  static TabBarTheme get tabBarTheme => const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicatorColor: primaryColor,
        labelStyle: TextStyle(
          fontSize: fontSizeM,
          fontWeight: fontWeightSemiBold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeM,
          fontWeight: fontWeightRegular,
        ),
      );

  // Switch Theme
  static SwitchThemeData get switchTheme => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return null;
        }),
      );

  // Checkbox Theme
  static CheckboxThemeData get checkboxTheme => CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        checkColor: WidgetStateProperty.all(textOnPrimaryColor),
      );

  // Radio Theme
  static RadioThemeData get radioTheme => RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      );

  // Divider Theme
  static DividerThemeData get dividerTheme => const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
        space: spacingM,
      );

  // Icon Theme
  static IconThemeData get iconTheme => const IconThemeData(
        color: textSecondaryColor,
        size: iconSizeM,
      );

  // Floating Action Button Theme
  static FloatingActionButtonThemeData get floatingActionButtonTheme =>
      FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
        elevation: elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusXl),
        ),
      );

  // Utility Methods
  static Color getSkillLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return beginnerColor;
      case 'intermediate':
        return intermediateColor;
      case 'advanced':
        return advancedColor;
      case 'expert':
        return expertColor;
      default:
        return textSecondaryColor;
    }
  }

  static IconData getSkillLevelIcon(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Icons.circle;
      case 'intermediate':
        return Icons.radio_button_checked;
      case 'advanced':
        return Icons.star_half;
      case 'expert':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technical':
        return const Color(0xFF4299E1);
      case 'leadership':
        return const Color(0xFF9F7AEA);
      case 'communication':
        return const Color(0xFF48BB78);
      case 'project management':
        return const Color(0xFFED8936);
      case 'finance':
        return const Color(0xFF38B2AC);
      case 'legal':
        return const Color(0xFFE53E3E);
      case 'administrative':
        return const Color(0xFFD69E2E);
      case 'language':
        return const Color(0xFF667EEA);
      case 'certification':
        return const Color(0xFFF56565);
      default:
        return textSecondaryColor;
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'technical':
        return Icons.code;
      case 'leadership':
        return Icons.group;
      case 'communication':
        return Icons.chat;
      case 'project management':
        return Icons.assignment;
      case 'finance':
        return Icons.attach_money;
      case 'legal':
        return Icons.gavel;
      case 'administrative':
        return Icons.admin_panel_settings;
      case 'language':
        return Icons.translate;
      case 'certification':
        return Icons.verified;
      default:
        return Icons.help_outline;
    }
  }

  // Animation Durations
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Screen Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Z-Index Values
  static const int zIndexBackground = 0;
  static const int zIndexContent = 1;
  static const int zIndexAppBar = 10;
  static const int zIndexDrawer = 20;
  static const int zIndexModal = 30;
  static const int zIndexTooltip = 40;
  static const int zIndexSnackBar = 50;

  // Grid System
  static const int maxColumns = 12;
  static const double gutterWidth = spacingM;

  // Loading States
  static Widget get defaultLoadingWidget => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );

  static Widget get smallLoadingWidget => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );

  // Empty State Widget
  static Widget emptyStateWidget({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? action,
  }) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSizeXxl,
              color: textTertiaryColor,
            ),
            const SizedBox(height: spacingL),
            Text(
              title,
              style: const TextStyle(
                fontSize: fontSizeXl,
                fontWeight: fontWeightMedium,
                color: textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: spacingS),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: fontSizeM,
                  color: textTertiaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: spacingL),
              action,
            ],
          ],
        ),
      );

  // Error State Widget
  static Widget errorStateWidget({
    required String title,
    String? subtitle,
    VoidCallback? onRetry,
  }) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: iconSizeXxl,
              color: errorColor,
            ),
            const SizedBox(height: spacingL),
            Text(
              title,
              style: const TextStyle(
                fontSize: fontSizeXl,
                fontWeight: fontWeightMedium,
                color: textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: spacingS),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: fontSizeM,
                  color: textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: spacingL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
}