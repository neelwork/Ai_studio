import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Regular
  static final TextStyle regular12 = _textStyle(12, FontWeight.w400);
  static final TextStyle regular14 = _textStyle(14, FontWeight.w400);
  static final TextStyle regular16 = _textStyle(16, FontWeight.w400);
  static final TextStyle regular18 = _textStyle(18, FontWeight.w400);
  static final TextStyle regular20 = _textStyle(20, FontWeight.w400);
  static final TextStyle regular22 = _textStyle(22, FontWeight.w400);
  static final TextStyle regular24 = _textStyle(24, FontWeight.w400);
  static final TextStyle regular28 = _textStyle(28, FontWeight.w400);
  static final TextStyle regular32 = _textStyle(32, FontWeight.w400);

  // Medium
  static final TextStyle medium10 = _textStyle(10, FontWeight.w500);
  static final TextStyle medium12 = _textStyle(12, FontWeight.w500);
  static final TextStyle medium14 = _textStyle(14, FontWeight.w500);
  static final TextStyle medium16 = _textStyle(16, FontWeight.w500);
  static final TextStyle medium18 = _textStyle(18, FontWeight.w500);
  static final TextStyle medium20 = _textStyle(20, FontWeight.w500);
  static final TextStyle medium22 = _textStyle(22, FontWeight.w500);
  static final TextStyle medium24 = _textStyle(24, FontWeight.w500);
  static final TextStyle medium28 = _textStyle(28, FontWeight.w500);
  static final TextStyle medium32 = _textStyle(32, FontWeight.w500);

  // SemiBold
  static final TextStyle semiBold12 = _textStyle(12, FontWeight.w600);
  static final TextStyle semiBold14 = _textStyle(14, FontWeight.w600);
  static final TextStyle semiBold16 = _textStyle(16, FontWeight.w600);
  static final TextStyle semiBold18 = _textStyle(18, FontWeight.w600);
  static final TextStyle semiBold20 = _textStyle(20, FontWeight.w600);
  static final TextStyle semiBold22 = _textStyle(22, FontWeight.w600);
  static final TextStyle semiBold24 = _textStyle(24, FontWeight.w600);
  static final TextStyle semiBold28 = _textStyle(28, FontWeight.w600);
  static final TextStyle semiBold32 = _textStyle(32, FontWeight.w600);

  // Bold
  static final TextStyle bold12 = _textStyle(12, FontWeight.w700);
  static final TextStyle bold14 = _textStyle(14, FontWeight.w700);
  static final TextStyle bold16 = _textStyle(16, FontWeight.w700);
  static final TextStyle bold18 = _textStyle(18, FontWeight.w700);
  static final TextStyle bold20 = _textStyle(20, FontWeight.w700);
  static final TextStyle bold22 = _textStyle(22, FontWeight.w700);
  static final TextStyle bold24 = _textStyle(24, FontWeight.w700);
  static final TextStyle bold28 = _textStyle(28, FontWeight.w700);
  static final TextStyle bold32 = _textStyle(32, FontWeight.w700);

  // Private method to avoid repetition
  static TextStyle _textStyle(double size, FontWeight weight) {
    return GoogleFonts.lexend(
      fontSize: size,
      fontWeight: weight,
      color: AppColors.black,
    );
  }
}


