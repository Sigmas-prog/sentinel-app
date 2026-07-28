import 'package:flutter/material.dart';

class SentinelTheme {
  static const background = Color(0xFF061018);
  static const panel = Color(0xDD0B1D29);
  static const cyan = Color(0xFF29D9FF);
  static const green = Color(0xFF49F2A5);
  static const violet = Color(0xFFB98CFF);
  static const muted = Color(0xFF8BA5B3);

  static ThemeData get data => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        fontFamily: 'SentinelMono',
        colorScheme: const ColorScheme.dark(
          primary: cyan,
          secondary: green,
          surface: panel,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFD6F5FF)),
          bodySmall: TextStyle(color: muted),
          titleMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
      );
}
