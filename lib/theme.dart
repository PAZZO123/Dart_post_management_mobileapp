import 'package:flutter/material.dart';

class AppTheme {
  // Rwanda flag colors
  static const Color rwandaBlue = Color(0xFF20603D);   // Deep green (Rwanda flag)
  static const Color rwandaGold = Color(0xFFE5BE01);   // Yellow (Rwanda flag)
  static const Color rwandaRed = Color(0xFF20603D);
  static const Color primaryGreen = Color(0xFF1A7A4A);
  static const Color lightGreen = Color(0xFF4CAF82);
  static const Color darkGreen = Color(0xFF0D4A2A);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color backgroundGrey = Color(0xFFF5F7F5);
  static const Color cardWhite = Color(0xFFFFFFFF);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentGold,
        surface: cardWhite,
        background: backgroundGrey,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: primaryGreen),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: cardWhite,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      scaffoldBackgroundColor: backgroundGrey,
    );
  }
}
