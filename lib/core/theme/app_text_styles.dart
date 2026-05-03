import 'package:flutter/material.dart';

/// Typography scale inspired by Apple Music.
/// Uses the system font stack for each platform.
@immutable
class AppTextStyles {
  final TextStyle pageTitle;
  final TextStyle sectionHeader;
  final TextStyle cardTitle;
  final TextStyle body;
  final TextStyle caption;
  final TextStyle button;
  final TextStyle trackTitle;
  final TextStyle trackArtist;
  final TextStyle playerTitle;
  final TextStyle playerArtist;

  const AppTextStyles({
    required this.pageTitle,
    required this.sectionHeader,
    required this.cardTitle,
    required this.body,
    required this.caption,
    required this.button,
    required this.trackTitle,
    required this.trackArtist,
    required this.playerTitle,
    required this.playerArtist,
  });

  factory AppTextStyles.forColor(Color onSurfaceColor) {
    final baseColor = onSurfaceColor;
    final secondaryColor = baseColor.withValues(alpha: 0.55);

    return AppTextStyles(
      pageTitle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      sectionHeader: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: -0.3,
      ),
      cardTitle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      body: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      caption: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
        letterSpacing: -0.1,
      ),
      button: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      trackTitle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      trackArtist: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
        letterSpacing: -0.1,
      ),
      playerTitle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      playerArtist: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
        letterSpacing: -0.1,
      ),
    );
  }
}
