import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  // ── Dark Theme ────────────────────────────────────────────────────────────

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scaffoldBg: AppColors.darkBackground,
        surfaceColor: AppColors.surface1Dark,
        surfaceTint: AppColors.surface2Dark,
        onSurface: AppColors.lightText,
        cardColor: AppColors.surface1Dark,
        subText: AppColors.grey,
        dividerColor: AppColors.surface3Dark,
        navBg: AppColors.surface1Dark,
      );

  // ── Light Theme ───────────────────────────────────────────────────────────

  static ThemeData get light => _build(
        brightness: Brightness.light,
        scaffoldBg: AppColors.lightBackground,
        surfaceColor: AppColors.surface1Light,
        surfaceTint: AppColors.surface2Light,
        onSurface: AppColors.darkText,
        cardColor: AppColors.surface1Light,
        subText: const Color(0xFF546E65),
        dividerColor: AppColors.surface3Light,
        navBg: AppColors.surface1Light,
      );

  // ── Shared builder ────────────────────────────────────────────────────────

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffoldBg,
    required Color surfaceColor,
    required Color surfaceTint,
    required Color onSurface,
    required Color cardColor,
    required Color subText,
    required Color dividerColor,
    required Color navBg,
  }) {
    final isDark = brightness == Brightness.dark;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.softEmerald,
        brightness: brightness,
        primary: AppColors.softEmerald,
        onPrimary: AppColors.lightText,
        secondary: AppColors.deepGreen,
        onSecondary: AppColors.lightText,
        surface: surfaceColor,
        onSurface: onSurface,
        error: AppColors.missed,
      ),
    );

    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.dmSans(
          fontSize: 32, fontWeight: FontWeight.w700, color: onSurface),
      displayMedium: GoogleFonts.dmSans(
          fontSize: 28, fontWeight: FontWeight.w700, color: onSurface),
      headlineLarge: GoogleFonts.dmSans(
          fontSize: 24, fontWeight: FontWeight.w700, color: onSurface),
      headlineMedium: GoogleFonts.dmSans(
          fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
      titleLarge: GoogleFonts.dmSans(
          fontSize: 18, fontWeight: FontWeight.w600, color: onSurface),
      titleMedium: GoogleFonts.dmSans(
          fontSize: 16, fontWeight: FontWeight.w500, color: onSurface),
      bodyLarge: GoogleFonts.dmSans(
          fontSize: 16, fontWeight: FontWeight.w400, color: onSurface),
      bodyMedium: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w400, color: onSurface),
      bodySmall: GoogleFonts.dmSans(
          fontSize: 12, fontWeight: FontWeight.w400, color: subText),
      labelLarge: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w600, color: onSurface),
    );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBg,
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navBg,
        indicatorColor: AppColors.softEmerald.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.softEmerald);
          }
          return IconThemeData(color: subText);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.softEmerald);
          }
          return GoogleFonts.dmSans(
              fontSize: 12, fontWeight: FontWeight.w400, color: subText);
        }),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softEmerald,
          foregroundColor: AppColors.lightText,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle:
              GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.softEmerald
              : subText;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.softEmerald.withValues(alpha: 0.3)
              : subText.withValues(alpha: 0.2);
        }),
      ),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.surface3Dark : AppColors.surface2Light,
        contentTextStyle: GoogleFonts.dmSans(color: onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: navBg,
        selectedItemColor: AppColors.softEmerald,
        unselectedItemColor: subText,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
