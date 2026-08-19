import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary1 = Color(0xFF41AC85);
  static const primary2 = Color(0xFF093726);
  static const white = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF6C6C78);
  static const onSurface = Color(0xFF131317);
  static const line = Color(0xFFE5E5E5);
  static const critical = Color(0xFFEB5A5A);
  static const warning = Color(0xFFFABE3C);
  static const success = Color(0xFF188038);
  static const surface = Color(0xFFF5F5F5);
  static const blueColor = Color(0xFF2DC28D);

  static const primary = primary1;
  static const primaryDark = primary2;
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'LexendDeca',
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    surface: AppColors.white,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    titleLarge: TextStyle(
      fontSize: 22,

      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.secondary,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
);
