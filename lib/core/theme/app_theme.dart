import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Central theme configuration for the app.
/// Supports both light and dark modes with an Apple Music-like aesthetic.
class AppTheme {
  static ThemeData themeData(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final textStyles = AppTextStyles.forColor(colors.onSurface);

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.primaryVariant,
        onSecondary: colors.onPrimary,
        error: colors.error,
        onError: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background.withValues(alpha: 0.85),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textStyles.pageTitle.copyWith(fontSize: 28),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: colors.onSurface,
        unselectedItemColor: colors.onSurfaceVariant,
        selectedLabelStyle: textStyles.caption.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textStyles.caption,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        textColor: colors.onSurface,
        iconColor: colors.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: colors.onSurfaceVariant, size: 24),
      primaryIconTheme: IconThemeData(color: colors.onSurface, size: 24),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.onSurface,
        inactiveTrackColor: colors.onSurfaceVariant.withValues(alpha: 0.3),
        thumbColor: colors.onSurface,
        overlayColor: colors.onSurface.withValues(alpha: 0.1),
        trackHeight: 3,
      ),
      textTheme: TextTheme(
        displayLarge: textStyles.pageTitle,
        headlineMedium: textStyles.sectionHeader,
        titleMedium: textStyles.cardTitle,
        bodyMedium: textStyles.body,
        bodySmall: textStyles.caption,
        labelLarge: textStyles.button,
      ),
    );
  }

  /// Convenience extension to read AppColors from BuildContext.
  static AppColors colorsOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  }

  /// Convenience extension to read AppTextStyles from BuildContext.
  static AppTextStyles textStylesOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
    return AppTextStyles.forColor(colors.onSurface);
  }
}
