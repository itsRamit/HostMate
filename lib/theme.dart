import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const base1 = Color(0xFF0D0D0D);
  static const base2 = Color(0xFF101010);

  // Surface
  static const surfaceWhite1 = Color(0xFFFFFFFF);
  static const surfaceWhite2 = Color(0xFFFFFFFF);
  static const surfaceBlack1 = Color(0xFF101010);
  static const surfaceBlack2 = Color(0xFF101010);
  static const surfaceBlack3 = Color(0xFF101010);

  // Text
  static const text1 = Color(0xFFFFFFFF); // 100%
  static const text2 = Color(0xFFFFFFFF); // 72%
  static const text3 = Color(0xFFFFFFFF); // 48%
  static const text4 = Color(0xFFFFFFFF); // 24%
  static const text5 = Color(0xFFFFFFFF); // 10%

  // Colors
  static const primaryAccent = Color(0xFF913BFF);
  static const secondaryAccent = Color(0xFF3B59FF);
  static const positive = Color(0xFF5BEB3B);
  static const negative = Color(0xFFD6274A);

  // Borders
  static const border1 = Color(0xFFFFFFFF);
  static const border2 = Color(0xFF1A1A1A);
  static const border3 = Color(0xFF1F1F1F);

  // Effects
  static const bgBlur12 = Color(0x1FFFFFFF);
  static const bgBlur40 = Color(0x66FFFFFF);
  static const bgBlur80 = Color(0xCC000000);
}

class AppTextStyles {
  static const h1Bold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
    letterSpacing: -0.03,
    height: 1.2,
  );

  static const h2Bold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
    letterSpacing: -0.02,
    height: 1.25,
  );

  static const bodyMRegular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
  );

  static const bodyMBold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const bodySRegular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text3,
  );
}

final appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.base2,
  textTheme: const TextTheme(
    bodyLarge: AppTextStyles.bodyMRegular,
    bodyMedium: AppTextStyles.bodySRegular,
    headlineMedium: AppTextStyles.h2Bold,
    headlineLarge: AppTextStyles.h1Bold,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceBlack2,
    hintStyle: AppTextStyles.bodySRegular,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border3, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryAccent, width: 1.5),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.surfaceBlack1,
      foregroundColor: AppColors.text1,
      textStyle: AppTextStyles.bodyMBold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),
);
