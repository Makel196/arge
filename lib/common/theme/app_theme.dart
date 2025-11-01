import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFD22630);
  static const Color primaryDark = Color(0xFF9C1B26);
  static const Color secondary = Color(0xFF3F51B5);
  static const Color accent = Color(0xFF4DB7FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FB);
  static const Color muted = Color(0xFF5E6B7E);
  static const Color softBorder = Color(0xFFE3E8F3);
}

enum AppFeature { naming, standards, materials, projects, calculations }

class FeaturePalette {
  const FeaturePalette({
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
}

class AppSpacing {
  AppSpacing._();

  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;
}

class AppRadius {
  AppRadius._();

  // iOS Human Interface Guidelines standart radius değerleri
  static const BorderRadius r8 = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius r10 = BorderRadius.all(Radius.circular(10.0));
  static const BorderRadius r12 = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius r13 = BorderRadius.all(
    Radius.circular(13.0),
  ); // iOS default
  static const BorderRadius r14 = BorderRadius.all(Radius.circular(14.0));
  static const BorderRadius r16 = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius r20 = BorderRadius.all(Radius.circular(20.0));
  static const BorderRadius r24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius r48 = BorderRadius.all(Radius.circular(48));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));

  // iOS'un en çok kullandığı radius (CupertinoButton, CupertinoTextField vb.)
  static const BorderRadius cupertino = BorderRadius.all(Radius.circular(999));
}

class AppTheme {
  AppTheme._();

  static FeaturePalette featurePalette(AppFeature feature) =>
      _featurePalettes[feature]!;

  static Color soften(Color color, double amount) {
    final double t = amount.clamp(0.0, 1.0);
    return Color.lerp(color, Colors.white, t)!;
  }

  static CupertinoThemeData get cupertino => CupertinoThemeData(
    primaryColor: AppColors.primary,
    barBackgroundColor: AppColors.surface.withAlpha((0.92 * 255).round()),
    scaffoldBackgroundColor: AppColors.background,
    applyThemeToAll: true,
    textTheme: CupertinoTextThemeData(
      textStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.muted,
        letterSpacing: 0.1,
      ),
      navTitleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      navLargeTitleTextStyle: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
        letterSpacing: 0.8,
      ),
      pickerTextStyle: GoogleFonts.poppins(fontSize: 16),
      tabLabelTextStyle: GoogleFonts.poppins(fontSize: 12),
      actionTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.secondary,
      ),
    ),
  );

  static ThemeData get materialLight {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(surface: AppColors.surface);

    final base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.primaryDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: AppColors.muted),
      ),
      cupertinoOverrideTheme: cupertino,
    );
  }

  static const Map<AppFeature, FeaturePalette> _featurePalettes = {
    AppFeature.naming: FeaturePalette(
      primary: Color(0xFFE35A63),
      secondary: Color(0xFFF48E95),
      accent: Color(0xFFFFE0D6),
    ),
    AppFeature.standards: FeaturePalette(
      primary: Color(0xFF5E76E0),
      secondary: Color(0xFF92A5F3),
      accent: Color(0xFFE3E9FF),
    ),
    AppFeature.materials: FeaturePalette(
      primary: Color(0xFF39B39A),
      secondary: Color(0xFF72D2BC),
      accent: Color(0xFFE1F6EE),
    ),
    AppFeature.projects: FeaturePalette(
      primary: Color(0xFF8A68DD),
      secondary: Color(0xFFB59EF3),
      accent: Color(0xFFEEE5FF),
    ),
    AppFeature.calculations: FeaturePalette(
      primary: Color(0xFFF98B47),
      secondary: Color(0xFFFBB283),
      accent: Color(0xFFFFE6D1),
    ),
  };
}
