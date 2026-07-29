import 'package:flutter/material.dart';

class SentinelTheme {
  static const background = Color(0xFF020609);
  static const panel = Color(0xE6081117);
  static const cyan = Color(0xFF00FFCC);
  static const magenta = Color(0xFFFF00FF);
  static const green = Color(0xFF00FF88);
  static const warning = Color(0xFFFFB800);
  static const muted = Color(0xFF7EA39F);
  static const text = Color(0xFFE4FFF9);

  static ThemeData get data => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'SentinelMono',
        splashFactory: NoSplash.splashFactory,
        colorScheme: const ColorScheme.dark(
          primary: cyan,
          secondary: magenta,
          tertiary: green,
          surface: panel,
          error: Color(0xFFFF4567),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: cyan,
            fontFamily: 'SentinelMono',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.2,
          ),
          iconTheme: IconThemeData(color: cyan),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: text, height: 1.35),
          bodyMedium: TextStyle(color: text, height: 1.35),
          bodySmall: TextStyle(color: muted, height: 1.3),
          titleLarge: TextStyle(
            color: cyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
          ),
          titleMedium: TextStyle(
            color: text,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xCC020609),
          hintStyle: TextStyle(color: muted),
          labelStyle: TextStyle(color: cyan),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x6600FFCC)),
            borderRadius: BorderRadius.zero,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: cyan, width: 1.5),
            borderRadius: BorderRadius.zero,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF4567)),
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
}
