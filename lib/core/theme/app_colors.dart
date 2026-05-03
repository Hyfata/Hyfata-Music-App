import 'package:flutter/material.dart';

/// Light & Dark color tokens for the Hyfata Music App.
/// Designed to evoke Apple Music's refined aesthetic.
@immutable
class AppColors {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color onBackground;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color divider;
  final Color playerBarBg;
  final Color sidebarBg;
  final Color overlay;
  final Color error;
  final Color success;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.onBackground,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.divider,
    required this.playerBarBg,
    required this.sidebarBg,
    required this.overlay,
    required this.error,
    required this.success,
  });

  static const AppColors dark = AppColors(
    background: Color(0xFF000000),
    surface: Color(0xFF121212),
    surfaceVariant: Color(0xFF1C1C1C),
    primary: Color(0xFF6C5CE7),
    primaryVariant: Color(0xFF5B4BD4),
    onPrimary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFFB3B3B3),
    divider: Color(0xFF2A2A2A),
    playerBarBg: Color(0xFF1A1A1A),
    sidebarBg: Color(0xFF0A0A0A),
    overlay: Color(0x99000000),
    error: Color(0xFFE74C3C),
    success: Color(0xFF2ECC71),
  );

  static const AppColors light = AppColors(
    background: Color(0xFFF2F2F7),
    surface: Colors.white,
    surfaceVariant: Color(0xFFE5E5EA),
    primary: Color(0xFF6C5CE7),
    primaryVariant: Color(0xFF5B4BD4),
    onPrimary: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
    onSurfaceVariant: Color(0xFF6E6E73),
    divider: Color(0xFFE5E5EA),
    playerBarBg: Colors.white,
    sidebarBg: Color(0xFFF9F9FB),
    overlay: Color(0x66000000),
    error: Color(0xFFE74C3C),
    success: Color(0xFF2ECC71),
  );

  /// Accent gradients for hero banners, player overlays, etc.
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, primaryVariant],
      );
}
