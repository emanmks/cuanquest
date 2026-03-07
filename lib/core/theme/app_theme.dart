import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuanquest/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: _textTheme,
        appBarTheme: _appBarTheme,
        cardTheme: _cardTheme,
        navigationBarTheme: _navigationBarTheme,
        navigationRailTheme: _navigationRailTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        filledButtonTheme: _filledButtonTheme,
        dividerTheme: const DividerThemeData(
          color: AppColors.borderMuted,
          thickness: 1,
        ),
      );

  // ── Color Scheme ──────────────────────────────────────────────────────────

  static const _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onBackground,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onBackground,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onBackground,
    error: AppColors.error,
    onError: AppColors.onPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    outline: AppColors.borderMuted,
    outlineVariant: AppColors.borderMuted,
  );

  // ── Typography ────────────────────────────────────────────────────────────

  static TextTheme get _textTheme =>
      GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.onBackground,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.onBackground,
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
          headlineLarge: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.onBackground,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.onBackground,
            letterSpacing: 0.5,
          ),
          labelMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          labelSmall: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      );

  // ── AppBar ────────────────────────────────────────────────────────────────

  static const _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.onBackground,
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      color: AppColors.onBackground,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    ),
  );

  // ── Card ──────────────────────────────────────────────────────────────────

  static const _cardTheme = CardThemeData(
    elevation: 0,
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide(color: AppColors.borderMuted, width: 2),
    ),
    margin: EdgeInsets.zero,
  );

  // ── Navigation Bar ────────────────────────────────────────────────────────

  static final _navigationBarTheme = NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    indicatorColor: AppColors.primaryContainer,
    elevation: 0,
    shadowColor: Colors.transparent,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        color: selected ? AppColors.primary : AppColors.onSurface,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.3,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return IconThemeData(
        color: selected ? AppColors.primary : AppColors.onSurface,
        size: 22,
      );
    }),
  );

  // ── Navigation Rail ───────────────────────────────────────────────────────

  static const _navigationRailTheme = NavigationRailThemeData(
    backgroundColor: AppColors.surface,
    elevation: 0,
    indicatorColor: AppColors.primaryContainer,
    selectedIconTheme: IconThemeData(color: AppColors.primary, size: 22),
    unselectedIconTheme: IconThemeData(color: AppColors.onSurface, size: 22),
    selectedLabelTextStyle: TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
      fontSize: 11,
    ),
    unselectedLabelTextStyle: TextStyle(
      color: AppColors.onSurface,
      fontWeight: FontWeight.w500,
      fontSize: 11,
    ),
  );

  // ── Buttons ───────────────────────────────────────────────────────────────

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.surfaceVariant;
        }
        return AppColors.primary;
      }),
      foregroundColor: WidgetStateProperty.all(AppColors.onPrimary),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.8),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
  );

  static final _filledButtonTheme = FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.primary),
      foregroundColor: WidgetStateProperty.all(AppColors.onPrimary),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.8),
      ),
    ),
  );
}
