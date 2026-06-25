import 'package:flutter/material.dart';

class AppThemes {
  // Custom Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0F766E), // Slate Teal
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
      
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0F766E),
        secondary: Color(0xFF0D9488),
        surface: Colors.white,
        background: Color(0xFFF8FAFC),
        error: Color(0xFFE11D48), // Rose 600
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF0F172A), // Slate 900
        onBackground: Color(0xFF0F172A),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF0F766E),
        unselectedItemColor: Color(0xFF94A3B8), // Slate 400
        selectedIconTheme: IconThemeData(size: 26),
        unselectedIconTheme: IconThemeData(size: 22),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9), // Slate 100
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5), // Slate 200
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE11D48), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE11D48), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF475569)), // Slate 600
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // Slate 400
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F766E),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      iconTheme: const IconThemeData(
        color: Color(0xFF0F766E),
      ),
      
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0), // Slate 200
        thickness: 1,
      ),
    );
  }

  // Custom Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF14B8A6), // Teal 400 (Vibrant Neon Teal)
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF14B8A6),
        secondary: Color(0xFF8B5CF6), // Violet 500 (Vibrant Accent)
        surface: Color(0xFF1E293B), // Slate 800
        background: Color(0xFF0F172A),
        error: Color(0xFFF43F5E), // Rose 500
        onPrimary: Color(0xFF0F172A), // Deep Slate for readability on Teal
        onSecondary: Colors.white,
        onSurface: Color(0xFFF1F5F9), // Slate 100
        onBackground: Color(0xFFF1F5F9),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B), // Slate 800
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF334155), width: 1), // Slate 700
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E293B),
        selectedItemColor: Color(0xFF14B8A6),
        unselectedItemColor: Color(0xFF64748B), // Slate 500
        selectedIconTheme: IconThemeData(size: 26),
        unselectedIconTheme: IconThemeData(size: 22),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F172A), // Slate 900
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5), // Slate 700
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)), // Slate 400
        hintStyle: const TextStyle(color: Color(0xFF475569)), // Slate 600
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF14B8A6),
          foregroundColor: const Color(0xFF0F172A),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      iconTheme: const IconThemeData(
        color: Color(0xFF14B8A6),
      ),
      
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155), // Slate 700
        thickness: 1,
      ),
    );
  }
}
