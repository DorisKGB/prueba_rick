import 'package:flutter/material.dart';

mixin AppTypography {
  static TextStyle get headline1 => TextStyle(fontSize: 50, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  static TextStyle get headline2 => TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  static TextStyle get subtitle1 => TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  static TextStyle get subtitle2 => TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  static TextStyle get body1 => TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Poppins');
  static TextStyle get body2 => TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: 'Poppins');
  static TextStyle get body3 => TextStyle(fontSize: 10, fontWeight: FontWeight.normal, fontFamily: 'Poppins');
  static TextStyle get body4 => TextStyle(fontSize: 18, fontWeight: FontWeight.normal, fontFamily: 'Poppins');
  static TextStyle get button => TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  static TextStyle get button1 => TextStyle(fontSize: 18, fontWeight: FontWeight.normal, fontFamily: 'Poppins');
}


