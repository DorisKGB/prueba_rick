import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'typographic.dart';

class AppStyle with AppTypography {
  static const appColors = AppColors(
    primary: Color(0xFF004899),
    secondary: Color(0xFFe41520),
    neutral: Color.fromRGBO(255, 255, 255, 1),
    neutral1: Color.fromRGBO(234, 234, 234, 1),
    neutral2: Color.fromRGBO(212, 212, 212, 1),
    neutral3: Color.fromRGBO(148, 148, 148, 1),
    neutral4: Color.fromRGBO(127, 127, 127, 1),
    neutral5: Color.fromRGBO(105, 105, 105, 1),
    neutral6: Color.fromRGBO(84, 84, 84, 1),
    neutral7: Color.fromRGBO(62, 62, 62, 1),
    neutral8: Color.fromRGBO(41, 41, 41, 1),
    primary1C7CE0: Color(0xFF1C7CE0),
    primary004185: Color(0xFF004185),
    secondary972647: Color(0xFF972647),
    yelow: Colors.amber,
    green: Colors.green,
  );

  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    textTheme: createTextTheme(),
    //colorScheme: appColors.toColorScheme(),
    extensions: const <ThemeExtension<dynamic>>[appColors],
    scaffoldBackgroundColor: Color.fromARGB(255, 246, 246, 246),
    appBarTheme: AppBarTheme(
      //foregroundColor: appColors.primary,
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      centerTitle: false,
      titleTextStyle: AppTypography.body1.copyWith(
        color: appColors.neutral8,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(size: 40, color: appColors.neutral8),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.primary,
        side: BorderSide(color: appColors.primary),
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: appColors.primary,
        textStyle: AppTypography.button,
      ),
    ),
    cardTheme: CardThemeData(
      color: appColors.neutral,
      shadowColor: appColors.neutral3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: AppTypography.headline1,
      //const TextStyle(fontSize: 24, color: Colors.black),
    ),

    iconTheme: IconThemeData(size: 24, color: appColors.primary),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: AppTypography.headline1.copyWith(color: appColors.primary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: appColors.primary,
      selectionColor: appColors.primary.withOpacity(0.3),
      selectionHandleColor: appColors.primary,
    ),
  );

  static TextTheme createTextTheme() {
    //TextTheme bodyTextTheme = GoogleFonts.getTextTheme("Montserrat");
    //TextTheme displayTextTheme = GoogleFonts.getTextTheme("Lora");
    TextTheme textTheme = TextTheme(
      headlineLarge: AppTypography.headline1.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      headlineMedium: AppTypography.headline2.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      bodyLarge: AppTypography.body1.copyWith(overflow: TextOverflow.ellipsis),
      bodyMedium: AppTypography.body2.copyWith(overflow: TextOverflow.ellipsis),
      bodySmall: AppTypography.body3.copyWith(overflow: TextOverflow.ellipsis),
      labelLarge: AppTypography.subtitle1.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      labelMedium: AppTypography.subtitle2.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      titleMedium: AppTypography.button1.copyWith(
        overflow: TextOverflow.ellipsis,
      ),
      labelSmall: AppTypography.body4.copyWith(overflow: TextOverflow.ellipsis),
    );
    return textTheme;
  }
}
