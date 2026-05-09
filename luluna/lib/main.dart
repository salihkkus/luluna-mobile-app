import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'screens/onboarding_screen.dart';

import 'theme/app_theme.dart';



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

      theme: AppTheme.lightTheme,

      home: const OnboardingScreen(),

    );

  }

}