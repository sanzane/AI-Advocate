import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Serif family used for headings (maps to Noto Serif on Android).
const String kHeadingFont = 'serif';

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.cobalt,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.navy,
    onPrimary: Colors.white,
    secondary: AppColors.cobalt,
    onSecondary: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.danger,
    outline: AppColors.border,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.ivory,
  );

  final text = base.textTheme.apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  );

  TextStyle? heading(TextStyle? s) => s?.copyWith(
        fontFamily: kHeadingFont,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        letterSpacing: -0.2,
      );

  return base.copyWith(
    textTheme: text.copyWith(
      headlineMedium: heading(text.headlineMedium),
      headlineSmall: heading(text.headlineSmall),
      titleLarge: heading(text.titleLarge),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: text.bodyMedium?.copyWith(height: 1.45),
      bodyLarge: text.bodyLarge?.copyWith(height: 1.5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.ivory,
      foregroundColor: AppColors.navy,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.cobaltTint,
      elevation: 0,
      height: 68,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dividerColor: AppColors.border,
  );
}

/// Shared card decoration: white surface, hairline border, soft shadow.
BoxDecoration cardDecoration(
    {Color color = AppColors.surface, double radius = 14}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.border),
    boxShadow: const [
      BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 2)),
    ],
  );
}
