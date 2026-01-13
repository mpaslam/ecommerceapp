import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle priceText({
    required double fontSize,
    Color color = AppColors.accentBlue,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
    );
  }

  static TextStyle productCardPriceText({
    required double fontSize,
    Color color = AppColors.black,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle boldTitle({
    required double fontSize,
    Color color = AppColors.black,
    FontWeight fontWeight = FontWeight.bold,
    double height = 1.0,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle description({
    required double fontSize,
    Color color = AppColors.grey,
    FontWeight fontWeight = FontWeight.normal,
    double height = 1.0,
  }) {
 
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
    );
  }

  static TextStyle prominentLabel({
    required double fontSize,
    Color color = AppColors.white,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle buttonText({
    required double fontSize,
    Color color = AppColors.white,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    );
  }
}
