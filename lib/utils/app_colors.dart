import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6B46C1);
  static const Color secondaryPurple = Color(0xFF9333EA);
  static const Color darkPurple = Color(0xFF4C1D95);
  static const Color lightPink = Color(0xFFF3E8FF);

  // Background Colors
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkerBackground = Color(0xFF16213E);

  // Gradient Colors
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
      Color(0xFF0F0C29),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF9333EA),
      Color(0xFFEC4899),
    ],
  );

  static const LinearGradient purplePinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ],
  );

  // Text Colors
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFB3B3B3);
  static const Color hintText = Color(0xFF6B7280);

  // Input Field Colors
  static const Color inputBackground = Color(0x1AFFFFFF);
  static const Color inputBorder = Color(0x33FFFFFF);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}