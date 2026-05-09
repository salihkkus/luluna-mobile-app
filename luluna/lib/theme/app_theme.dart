import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Design System Colors
  static const Color surface = Color(0xFFFAF8FE);
  static const Color surfaceDim = Color(0xFFDAD9DE);
  static const Color surfaceBright = Color(0xFFFAF8FE);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF4F3F8);
  static const Color surfaceContainer = Color(0xFFEFEDF2);
  static const Color surfaceContainerHigh = Color(0xFFE9E7EC);
  static const Color surfaceContainerHighest = Color(0xFFE3E2E7);
  
  static const Color onSurface = Color(0xFF1A1B1F);
  static const Color onSurfaceVariant = Color(0xFF44474F);
  static const Color inverseSurface = Color(0xFF2F3034);
  static const Color inverseOnSurface = Color(0xFFF1F0F5);
  static const Color outline = Color(0xFF747780);
  static const Color outlineVariant = Color(0xFFC4C6D0);
  static const Color surfaceTint = Color(0xFF455E92);
  
  static const Color primary = Color(0xFF455E92);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFABC4FF);
  static const Color onPrimaryContainer = Color(0xFF375084);
  static const Color inversePrimary = Color(0xFFAEC6FF);
  
  static const Color secondary = Color(0xFF436468);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFC3E6EB);
  static const Color onSecondaryContainer = Color(0xFF47686C);
  
  static const Color tertiary = Color(0xFF79590A);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFE9BE69);
  static const Color onTertiaryContainer = Color(0xFF694C00);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  
  static const Color background = Color(0xFFFAF8FE);
  static const Color onBackground = Color(0xFF1A1B1F);
  static const Color surfaceVariant = Color(0xFFE3E2E7);
  
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double containerMargin = 20.0;
  static const double touchTargetMin = 48.0;
  
  // Border Radius
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius defaultRadius = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(24.0));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(32.0));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(48.0));
  
  // Text Styles
  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    letterSpacing: -0.02,
    color: onSurface,
  );
  
  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    color: onSurface,
  );
  
  static TextStyle get headlineSmall => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: onSurface,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 26 / 18,
    color: onSurface,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: onSurface,
  );
  
  static TextStyle get labelLarge => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.01,
    color: onSurface,
  );
  
  static TextStyle get labelMedium => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: onSurface,
  );
  
  static TextStyle get labelSmall => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    color: onSurface,
  );
  
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: onSurface,
  );
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        surfaceTint: surfaceTint,
        inverseSurface: inverseSurface,
        inversePrimary: inversePrimary,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: headlineLarge,
        displayMedium: headlineMedium,
        displaySmall: headlineSmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: headlineSmall,
        titleMedium: bodyLarge,
        titleSmall: bodyMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: headlineSmall,
        surfaceTintColor: surfaceTint,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        surfaceTintColor: surfaceTint,
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(touchTargetMin, touchTargetMin),
          padding: const EdgeInsets.symmetric(horizontal: lg, vertical: md),
          textStyle: labelLarge,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: outline, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(touchTargetMin, touchTargetMin),
          padding: const EdgeInsets.symmetric(horizontal: lg, vertical: md),
          textStyle: labelLarge,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(touchTargetMin, touchTargetMin),
          padding: const EdgeInsets.symmetric(horizontal: lg, vertical: md),
          textStyle: labelLarge,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: lg, vertical: 20),
        hintStyle: bodyMedium.copyWith(color: onSurfaceVariant),
        labelStyle: labelLarge.copyWith(color: onSurfaceVariant),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return surfaceContainerHigh;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary.withOpacity(0.5);
          }
          return surfaceContainerLow;
        }),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: surfaceContainerLow,
        thumbColor: primary,
        overlayColor: primary.withOpacity(0.1),
        valueIndicatorColor: primary,
        valueIndicatorTextStyle: labelLarge.copyWith(color: onPrimary),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceContainerLow,
        circularTrackColor: surfaceContainerLow,
      ),
    );
  }
}
