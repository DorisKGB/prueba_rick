import 'package:flutter/material.dart';
import 'package:prueba_rick/presentation/utils/theme/app_colors.dart';

extension DetailBuildContext on BuildContext {
  TextStyle get headline1 => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get headline2 => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get subtitle1 => Theme.of(this).textTheme.titleLarge!;
  TextStyle get subtitle2 => Theme.of(this).textTheme.titleSmall!;
  TextStyle get body1 => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get body2 => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get body3 => Theme.of(this).textTheme.bodySmall!;
  TextStyle get body4 => Theme.of(this).textTheme.labelSmall!;
  TextStyle get button1 => Theme.of(this).textTheme.titleMedium!;
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
