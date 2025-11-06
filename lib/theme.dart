import 'package:flutter/material.dart';
import 'utils/spacing.dart';

class AppColors {
  // Base
  static const base1 = Color(0xFF0D0D0D);
  static const base2 = Color(0xFF101010);

  // Surface
  static const surfaceWhite1 = Color(0x05FFFFFF); // 2% white overlay
  static const surfaceWhite2 = Color(0x0DFFFFFF); // 5% white overlay
  static const surfaceBlack1 = Color(0xFF101010); // 100%
  static const surfaceBlack2 = Color(0xFF101010); // 90%
  static const surfaceBlack3 = Color(0xFF101010); // 70%

  // Text (with visual opacity levels)
  static const text1 = Color(0xFFFFFFFF); // 100%
  static const text2 = Color(0xB8FFFFFF); // 72%
  static const text3 = Color(0x7AFFFFFF); // 48%
  static const text4 = Color(0x3DFFFFFF); // 24%
  static const text5 = Color(0x26FFFFFF); // 15%

  // Accents & Status
  static const primaryAccent = Color(0xFF913BFF);
  static const secondaryAccent = Color(0xFF3B59FF);
  static const positive = Color(0xFF5BEB3B);
  static const negative = Color(0xFFD6274A);

  // Borders
  static const border1 = Color(0x14FFFFFF); // 8%
  static const border2 = Color(0x1AFFFFFF); // 10%
  static const border3 = Color(0x40FFFFFF); // 25%

  // Effects
  static const bgBlur12 = Color(0x1FFFFFFF);
  static const bgBlur40 = Color(0x66FFFFFF);
  static const bgBlur80 = Color(0xCC000000);
}

class AppTextStyles {
  // Headings
  static const h1Bold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.03,
    height: 1.25,
    color: AppColors.text1,
  );

  static const h1Regular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.03,
    height: 1.25,
    color: AppColors.text2,
  );

  static const h2Bold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.25,
    color: AppColors.text1,
  );

  static const h2Regular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.02,
    height: 1.25,
    color: AppColors.text2,
  );

  static const h3Bold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01,
    height: 1.3,
    color: AppColors.text1,
  );

  static const h3Regular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.01,
    height: 1.3,
    color: AppColors.text2,
  );

  // Body
  static const bodyMRegular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.text2,
  );

  static const bodyMBold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.text1,
  );

  static const bodySRegular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text3,
  );

  static const bodySBold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.text1,
  );

  // Subtext / labels
  static const subTextRegular = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.text3,
  );

  static const subTextBold = TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.text1,
  );
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.base2,
  primaryColor: AppColors.primaryAccent,
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.h1Bold,
    displayMedium: AppTextStyles.h2Bold,
    headlineMedium: AppTextStyles.h3Bold,
    bodyLarge: AppTextStyles.bodyMRegular,
    bodyMedium: AppTextStyles.bodySRegular,
    labelSmall: AppTextStyles.subTextRegular,
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
