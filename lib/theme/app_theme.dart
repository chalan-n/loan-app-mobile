import 'package:flutter/material.dart';
import 'glassmorphism.dart';
import 'thai_fonts.dart';

/// 🎨 Theme System สำหรับ Ultra-Luxury Loan App
/// ออกแบบตามหลักการ Glassmorphism และ High-end Banking UI
class AppTheme {
  // 🎨 Color Palette
  static const Color deepNavy = Color(0xFF002D62);      // สีหลัก
  static const Color sapphireBlue = Color(0xFF0F52BA); // สีเน้นจุดสำคัญ
  static const Color snowWhite = Color(0xFFF8FAFC);    // พื้นหลังหลัก
  
  // 🔵 สีน้ำเงินอื่นๆ
  static const Color lightBlue = Color(0xFFE6F2FF);
  static const Color mediumBlue = Color(0xFFB3D9FF);
  static const Color darkBlue = Color(0xFF003D82);
  
  // ⚪ สีขาว/เทา
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF1F5F9);
  static const Color mediumGray = Color(0xFF94A3B8);
  static const Color darkGray = Color(0xFF475569);
  
  // ✨ สีพิเศษ
  static const Color accentGold = Color(0xFFFFD700);   // สีทองสำหรับความหรู
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  // 🌙 Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // 🎨 Color Scheme
      colorScheme: const ColorScheme.light(
        primary: deepNavy,
        secondary: sapphireBlue,
        surface: snowWhite,
        background: snowWhite,
        error: errorRed,
        onPrimary: pureWhite,
        onSecondary: pureWhite,
        onSurface: deepNavy,
        onBackground: deepNavy,
        onError: pureWhite,
      ),
      
      // 📝 Typography (รองรับภาษาไทย)
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        // Headlines
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: deepNavy,
          height: 1.2,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          color: deepNavy,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: deepNavy,
          height: 1.3,
          fontFamily: 'Inter',
        ),
        
        // Titles
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: deepNavy,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: deepNavy,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepNavy,
          height: 1.4,
        ),
        
        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkGray,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkGray,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mediumGray,
          height: 1.4,
        ),
        
        // Labels
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: deepNavy,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: deepNavy,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: mediumGray,
        ),
      ),
      
      // 🎯 Component Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepNavy,
          foregroundColor: pureWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepNavy,
          side: const BorderSide(color: deepNavy, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: sapphireBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
      
      // 📦 Card Theme
      cardTheme: CardTheme(
        color: pureWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: mediumBlue.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // 🎨 Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: mediumBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: mediumBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: sapphireBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: errorRed,
            width: 1,
          ),
        ),
        labelStyle: const TextStyle(
          color: mediumGray,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        hintStyle: const TextStyle(
          color: mediumGray,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // 🎯 App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: snowWhite,
        foregroundColor: deepNavy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: deepNavy,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: const ColorScheme.dark(
        primary: sapphireBlue,
        secondary: mediumBlue,
        surface: darkSurface,
        background: darkBackground,
        error: errorRed,
        onPrimary: pureWhite,
        onSecondary: pureWhite,
        onSurface: snowWhite,
        onBackground: snowWhite,
        onError: pureWhite,
      ),
      
      fontFamily: 'Inter',
      // Dark theme text styles...
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: snowWhite,
          height: 1.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: lightGray,
          height: 1.5,
        ),
      ),
    );
  }
}

/// 🎨 Glassmorphism Utilities
class GlassColors {
  static const Color glassWhite = Color(0x26FFFFFF); // 15% opacity
  static const Color glassLight = Color(0x40FFFFFF); // 25% opacity
  static const Color glassMedium = Color(0x59FFFFFF); // 35% opacity
  
  // สีกระจกสำหรับ Dark Theme
  static const Color glassDark = Color(0x26000000); // 15% opacity black
  static const Color glassDarkLight = Color(0x40000000); // 25% opacity black
}

/// 🌊 Premium Shadow Utilities
class PremiumShadows {
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: AppTheme.deepNavy.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppTheme.deepNavy.withOpacity(0.04),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppTheme.deepNavy.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppTheme.deepNavy.withOpacity(0.03),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: AppTheme.deepNavy.withOpacity(0.15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
