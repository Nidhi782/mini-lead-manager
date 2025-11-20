import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color scheme constants
class AppColors {
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color accentGreen = Color(0xFF7ED321);
  static const Color warningOrange = Color(0xFFF5A623);
  static const Color errorRed = Color(0xFFD0021B);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color neutralGrey = Color(0xFF9B9B9B);
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color darkSurfaceVariant = Color(0xFF3A3A3A);
}

// Spacing constants for consistent padding/margins
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Common padding values
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalSM =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXL =
      EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets paddingVerticalSM =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG =
      EdgeInsets.symmetric(vertical: lg);
}

// Border radius constants
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;

  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
}

// Light Theme - Bright CRM colors
ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentGreen,
      error: AppColors.errorRed,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onSurfaceVariant: AppColors.neutralGrey,
      surfaceContainerHighest: AppColors.backgroundLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A1A),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMD,
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: AppRadius.radiusSM,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSM,
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppRadius.radiusSM,
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 2,
        ),
      ),
      contentPadding: AppSpacing.paddingLG,
      filled: true,
      fillColor: AppColors.backgroundLight,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSM,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedColor: AppColors.primaryBlue.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: Color(0xFF1A1A1A)),
      secondaryLabelStyle: const TextStyle(color: AppColors.primaryBlue),
    ),
  );
}

// Dark Theme - Darker surfaces with accent colors
ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentGreen,
      error: AppColors.errorRed,
      surface: AppColors.darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: Colors.white,
      onSurfaceVariant: AppColors.neutralGrey,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMD,
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      color: AppColors.darkSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: AppRadius.radiusSM,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSM,
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppRadius.radiusSM,
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 2,
        ),
      ),
      contentPadding: AppSpacing.paddingLG,
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSM,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      selectedColor: AppColors.primaryBlue.withValues(alpha: 0.3),
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: AppColors.primaryBlue),
    ),
  );
}
