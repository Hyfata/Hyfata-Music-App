import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Convenient extension on BuildContext for theme access.
extension BuildContextThemeExt on BuildContext {
  AppColors get appColors => AppTheme.colorsOf(this);
  AppTextStyles get appTextStyles => AppTheme.textStylesOf(this);
  ThemeData get theme => Theme.of(this);
  Brightness get brightness => theme.brightness;
  bool get isDark => brightness == Brightness.dark;
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
