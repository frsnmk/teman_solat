import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2e646b);
  static const secondary = Color(0xFFE89042);

  static const white = Colors.white;
  static const black = Colors.black;
  static const darkBg = Color(0xFF121212);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors
            .primary, // Warna bibit (untuk menggenerate warna turunan lain)
        brightness: Brightness.light, // Racikan warnanya untuk mode siang
        primary: AppColors
            .primary, // Warna utama (biar gak kereplace pake warna generate-an si bibit yang kadang nakal),
        surface: AppColors.white, // Warna background untuk component
        onSurface: AppColors
            .black, // Warna teks untuk component (yang ada diatas background component)
      ),
      scaffoldBackgroundColor: AppColors.white,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        surface: AppColors.darkBg,
        onSurface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBg,
    );
  }
}
