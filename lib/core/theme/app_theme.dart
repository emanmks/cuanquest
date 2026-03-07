import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED), // Purple
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
