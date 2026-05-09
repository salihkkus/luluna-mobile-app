import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const LulunaApp());
}

class LulunaApp extends StatelessWidget {
  const LulunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'luluna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Otizmli çocuklar için sakinleştirici pastel tonlar
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFABC4FF), // Yumuşak mavi
          background: const Color(0xFFF8F9FA), // Off-white/Kirli beyaz
          primary: const Color(0xFFABC4FF),
          secondary: const Color(0xFFBEE1E6), // Mint yeşili tonu
        ),
        textTheme: GoogleFonts.poppinsTextTheme(), // Temiz ve yuvarlak hatlı tipografi
      ),
      home: const SplashScreen(),
    );
  }
}