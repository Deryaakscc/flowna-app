import 'package:flutter/material.dart';

class AppColors {
  // Ana Renkler
  static const Color primary = Color(0xFF1A237E); // Koyu lacivert
  static const Color secondary = Color(0xFF3949AB); // Orta lacivert
  static const Color accent = Color(0xFFE8EAF6);   // Çok açık lacivert
  static const Color error = Color(0xFFE53935);    // Hata rengi
  
  // Light Mode Renkler
  static const Color backgroundLight = Colors.white;
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textLightLight = Color(0xFFBDBDBD);
  
  // Dark Mode Renkler
  static const Color backgroundDark = Color(0xFF1E1E1E); // Biraz daha açık bir siyah
  static const Color surfaceDark = Color(0xFF2C2C2C);    // Biraz daha açık bir yüzey
  static const Color textPrimaryDark = Color(0xFFE0E0E0); // Daha parlak beyaz
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Daha parlak gri
  static const Color textLightDark = Color(0xFF808080);     // Orta gri
  
  // Özellik Renkleri
  static const Color water = Color(0xFF81D4FA);    // Su takibi için
  static const Color sleep = Color(0xFF9FA8DA);    // Uyku takibi için - lacivert tonu
  static const Color exercise = Color(0xFF5C6BC0);  // Egzersiz için - lacivert tonu
  static const Color nutrition = Color(0xFF3F51B5); // Beslenme için - lacivert tonu
  
  // Gradient Renkler
  static const List<Color> primaryGradient = [
    Color(0xFF1A237E),
    Color(0xFF3949AB),
  ];

  // Tema değişkenleri
  static Color get background => isDark ? backgroundDark : backgroundLight;
  static Color get surface => isDark ? surfaceDark : surfaceLight;
  static Color get textPrimary => isDark ? textPrimaryDark : textPrimaryLight;
  static Color get textSecondary => isDark ? textSecondaryDark : textSecondaryLight;
  static Color get textLight => isDark ? textLightDark : textLightLight;

  // Dark mode kontrolü
  static bool isDark = false;
} 