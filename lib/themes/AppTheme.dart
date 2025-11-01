import 'package:flutter/material.dart';
import 'AppColors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Quicksand',
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: AppColors.lightGradientEnd,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightText),
      titleLarge: TextStyle(color: AppColors.lightText),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightGradientEnd,
      surface: AppColors.lightSurface,
      onSurface: Colors.black87,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.lightText,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Quicksand',
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: AppColors.darkGradientEnd,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText),
      titleLarge: TextStyle(color: AppColors.darkText),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkGradientEnd,
      surface: AppColors.darkSurface,
      onSurface: Colors.white70,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.darkText,
      elevation: 0,
    ),
  );
}
