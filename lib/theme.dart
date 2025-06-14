import 'package:flutter/material.dart';

class BeautyTheme extends ThemeExtension<BeautyTheme> {
  final RadialGradient backgroundGradient;
  final Color primaryColor;
  final Color secondaryColor;

  BeautyTheme({
    required this.backgroundGradient,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  BeautyTheme copyWith({
    RadialGradient? backgroundGradient,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return BeautyTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  @override
  ThemeExtension<BeautyTheme> lerp(ThemeExtension<BeautyTheme>? other, double t) {
    if (other is! BeautyTheme) return this;
    return BeautyTheme(
      backgroundGradient: RadialGradient.lerp(
          backgroundGradient, other.backgroundGradient, t)!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
    );
  }
}

/// Light Mode Theme
final ThemeData beautyTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.pinkAccent,
    foregroundColor: Colors.white,
  ),
  textTheme: ThemeData.light().textTheme,
  extensions: <ThemeExtension<dynamic>>[
    BeautyTheme(
      backgroundGradient: RadialGradient(
        center: Alignment.center,
        colors: [
          const Color(0xFFB379DF).withOpacity(1.0),
          const Color(0xFFCC5854).withOpacity(0.08),
          const Color(0xFFB379DF).withOpacity(1.0),
        ],
        stops: const [0.0, 0.77, 1.0],
      ),
      primaryColor: const Color(0xFFB379DF),
      secondaryColor: const Color(0xFFCC5854),
    ),
  ],
);

/// Dark Mode Theme
final ThemeData beautyDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
  textTheme: ThemeData.dark().textTheme,
  extensions: <ThemeExtension<dynamic>>[
    BeautyTheme(
      backgroundGradient: RadialGradient(
        center: Alignment.center,
        colors: [
          const Color(0xFF1E1E2C),
          const Color(0xFF3C3C5C),
          const Color(0xFF1E1E2C),
        ],
        stops: const [0.0, 0.77, 1.0],
      ),
      primaryColor: const Color(0xFF9B59B6), // Soft purple
      secondaryColor: const Color(0xFFE91E63), // Pink accent
    ),
  ],
);
