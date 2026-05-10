import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/onboarding_screen.dart';

import 'theme/app_theme.dart';



void main() async {

  // .env dosyasını yükle (hata durumunda devam et)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('⚠️ .env dosyası yüklenemedi: $e');
    // Varsayılan değerler kullanılacak
  }

  runApp(const LulunaApp());

}



class LulunaApp extends StatelessWidget {

  const LulunaApp({super.key});



  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'luluna',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const OnboardingScreen(),

    );

  }

}