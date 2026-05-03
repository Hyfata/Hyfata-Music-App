/// Global constants for the Hyfata Music App.
class AppConstants {
  AppConstants._();

  static const String appName = 'Hyfata Music';

  // Layout breakpoints
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  // Sidebar widths
  static const double sidebarCollapsedWidth = 72;
  static const double sidebarExpandedWidth = 240;

  // Player bar heights
  static const double desktopPlayerBarHeight = 80;
  static const double mobileMiniPlayerHeight = 64;

  // Bottom tab bar
  static const double mobileBottomBarHeight = 64;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 250);
  static const Duration longAnimation = Duration(milliseconds: 400);

  // Spacing scale
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  // Artwork sizes
  static const double artworkThumbnail = 48;
  static const double artworkSmall = 56;
  static const double artworkMedium = 120;
  static const double artworkLarge = 200;
  static const double artworkHero = 280;
}
