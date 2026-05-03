import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../providers/theme_provider.dart';
import '../router/app_router.dart';

/// Settings page with grouped toggles and options.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = context.appTextStyles;
    final themeMode = ref.watch(themeModeProvider);
    final isDesktop = context.screenWidth >= AppConstants.desktopBreakpoint;

    String themeLabel;
    switch (themeMode) {
      case ThemeMode.light:
        themeLabel = 'Light';
        break;
      case ThemeMode.dark:
        themeLabel = 'Dark';
        break;
      default:
        themeLabel = 'System';
    }

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text('Settings', style: textStyles.pageTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () => context.push(AppRoutes.profile),
                ),
                const SizedBox(width: 8),
              ],
            ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          if (isDesktop)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 32, top: 32, bottom: 16),
                child: Text('Settings', style: textStyles.pageTitle),
              ),
            ),
          SliverToBoxAdapter(
            child: _SettingsSection(
              title: 'Appearance',
              children: [
                _SettingsTile(
                  icon: Icons.brightness_6_outlined,
                  title: 'Theme',
                  subtitle: themeLabel,
                  onTap: () => _showThemePicker(context, ref),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _SettingsSection(
              title: 'Playback',
              children: [
                _SettingsToggleTile(
                  icon: Icons.equalizer_outlined,
                  title: 'Sound Auto-Adjust (LUFS)',
                  subtitle: 'Normalize perceived loudness',
                  value: false, // TODO: Wire to settings provider
                  onChanged: (v) {},
                ),
                _SettingsToggleTile(
                  icon: Icons.download_outlined,
                  title: 'Offline Mode',
                  subtitle: 'Only play downloaded tracks',
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _SettingsSection(
              title: 'Discord',
              children: [
                _SettingsToggleTile(
                  icon: Icons.gamepad_outlined,
                  title: 'Discord Rich Presence',
                  subtitle: 'Show what you\'re listening to on Discord',
                  value: false,
                  onChanged: (v) {},
                ),
                _SettingsTile(
                  icon: Icons.group_add_outlined,
                  title: 'Invite Friends',
                  subtitle: 'Share listen-together links',
                  onTap: () {
                    // TODO: Share invite link
                  },
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _SettingsSection(
              title: 'Account',
              children: [
                _SettingsTile(
                  icon: Icons.login_outlined,
                  title: 'Hyfata Login',
                  subtitle: 'Sign in to sync playlists',
                  onTap: () {
                    // TODO: Trigger login
                  },
                ),
              ],
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.appColors.onSurface)),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.brightness_auto, color: context.appColors.onSurfaceVariant),
                  title: Text('System', style: TextStyle(color: context.appColors.onSurface)),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.light_mode, color: context.appColors.onSurfaceVariant),
                  title: Text('Light', style: TextStyle(color: context.appColors.onSurface)),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode, color: context.appColors.onSurfaceVariant),
                  title: Text('Dark', style: TextStyle(color: context.appColors.onSurface)),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    
    final textStyles = context.appTextStyles;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(title, style: textStyles.sectionHeader.copyWith(fontSize: 18)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.appColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    final textStyles = context.appTextStyles;

    return ListTile(
      leading: Icon(icon, color: context.appColors.onSurfaceVariant),
      title: Text(title, style: textStyles.body),
      subtitle: subtitle != null ? Text(subtitle!, style: textStyles.caption) : null,
      trailing: Icon(Icons.chevron_right, color: context.appColors.onSurfaceVariant, size: 20),
      onTap: onTap,
    );
  }
}

class _SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    
    final textStyles = context.appTextStyles;

    return ListTile(
      leading: Icon(icon, color: context.appColors.onSurfaceVariant),
      title: Text(title, style: textStyles.body),
      subtitle: subtitle != null ? Text(subtitle!, style: textStyles.caption) : null,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: context.appColors.primary,
      ),
    );
  }
}
