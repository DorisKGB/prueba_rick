import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color secondary;
  final Color primary;
  final Color primary1C7CE0;
  final Color primary004185;
  final Color secondary972647;
  final Color neutral;  
  final Color neutral1;
  final Color neutral2;
  final Color neutral3;
  final Color neutral4;
  final Color neutral5;
  final Color neutral6;
  final Color neutral7;
  final Color neutral8;
  final Color yelow;
  final Color green;
  const AppColors(    
      {required this.secondary,
      required this.primary,
      required this.neutral,
      required this.neutral1,
      required this.neutral2,
      required this.neutral3,
      required this.neutral4,
      required this.neutral5,
      required this.neutral6,
      required this.neutral7,
      required this.neutral8,
      required this.primary1C7CE0,
      required this.primary004185,
      required this.secondary972647,
      required this.yelow,
      required this.green 
      });

  @override
  ThemeExtension<AppColors> copyWith(
      {Color? secondary,
      Color? primary,
      Color? neutral,
      Color? neutral1,
      Color? neutral2,
      Color? neutral3,
      Color? neutral4,
      Color? neutral5,
      Color? neutral6,
      Color? neutral7,
      Color? neutral8,  
      Color? primary1C7CE0,
      Color? primary004185,
      Color? primary00387B, 
      Color? yelow,
      Color? green      
      }) {
    return AppColors(
        secondary: secondary ?? this.secondary,
        primary: primary ?? this.primary,
        neutral: neutral ?? this.neutral,
        neutral1: neutral1 ?? this.neutral1,
        neutral2: neutral2 ?? this.neutral2,
        neutral3: neutral3 ?? this.neutral3,
        neutral4: neutral4 ?? this.neutral4,
        neutral5: neutral5 ?? this.neutral5,
        neutral6: neutral6 ?? this.neutral6,
        neutral7: neutral7 ?? this.neutral7,
        neutral8: neutral8 ?? this.neutral8,
        primary1C7CE0: primary1C7CE0 ?? this.primary1C7CE0,
        primary004185: primary004185 ?? this.primary004185,
        secondary972647: primary00387B ?? this.secondary972647, 
        yelow: yelow?? this.yelow,
        green: green?? this.green
        );
  }

  @override
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return this;
  }

 /* ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primary01,      
      secondary: primary02,
    );
  }*/
}
