import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../router/app_router.dart';
import '../widgets/blur_container.dart';
import '../widgets/player_bar.dart';
import '../widgets/mini_player.dart';

/// Adaptive shell that switches between desktop sidebar layout
/// and mobile bottom-tab layout based on screen width.
class AdaptiveScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const AdaptiveScaffold({super.key, required this.child});

  @override
  ConsumerState<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends ConsumerState<AdaptiveScaffold> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home, path: AppRoutes.home),
    _NavItem(label: 'Search', icon: Icons.search_outlined, activeIcon: Icons.search, path: AppRoutes.search),
    _NavItem(label: 'Playlists', icon: Icons.library_music_outlined, activeIcon: Icons.library_music, path: AppRoutes.playlists),
    _NavItem(label: 'Settings', icon: Icons.settings_outlined, activeIcon: Icons.settings, path: AppRoutes.settings),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _currentIndex = index);
    context.go(_navItems[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= AppConstants.desktopBreakpoint;
    final colors = context.appColors;

    // Sync index with current route
    final location = GoRouterState.of(context).uri.path;
    final matchedIndex = _navItems.indexWhere((item) => item.path == location);
    if (matchedIndex != -1 && matchedIndex != _currentIndex) {
      _currentIndex = matchedIndex;
    }

    if (isDesktop) {
      return _DesktopLayout(
        navItems: _navItems,
        currentIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        colors: colors,
        child: widget.child,
      );
    }

    return _MobileLayout(
      navItems: _navItems.take(3).toList(),
      currentIndex: _currentIndex < 3 ? _currentIndex : 0,
      onDestinationSelected: _onDestinationSelected,
      colors: colors,
      child: widget.child,
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final List<_NavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final AppColors colors;
  final Widget child;

  const _DesktopLayout({
    required this.navItems,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PlayerBar(),
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: AppConstants.sidebarExpandedWidth,
                  color: colors.sidebarBg,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Logo / App name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Icon(Icons.music_note, color: colors.primary, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              'Hyfata',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Nav items
                      ...navItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isSelected = index == currentIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
                            ),
                            title: Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected ? colors.primary : colors.onSurfaceVariant,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            selected: isSelected,
                            selectedTileColor: colors.primary.withValues(alpha: 0.12),
                            onTap: () => onDestinationSelected(index),
                          ),
                        );
                      }),
                      const Spacer(),
                      // User avatar at bottom
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _UserAvatarCompact(),
                      ),
                    ],
                  ),
                ),
                // Divider
                VerticalDivider(width: 1, thickness: 1, color: colors.divider),
                // Content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final List<_NavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final AppColors colors;
  final Widget child;

  const _MobileLayout({
    required this.navItems,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content with padding for bottom bars
          Positioned.fill(
            bottom: AppConstants.mobileBottomBarHeight + AppConstants.mobileMiniPlayerHeight,
            child: child,
          ),
          // Mini player
          const Positioned(
            left: 0,
            right: 0,
            bottom: AppConstants.mobileBottomBarHeight,
            child: MiniPlayer(),
          ),
          // Bottom tab bar with blur
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: BlurContainer(
                height: AppConstants.mobileBottomBarHeight,
                borderRadius: BorderRadius.zero,
                blurSigma: 28,
                backgroundColor: colors.playerBarBg.withValues(alpha: 0.85),
                border: Border(
                  top: BorderSide(color: colors.divider, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: navItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = index == currentIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => onDestinationSelected(index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? colors.onSurface : colors.onSurfaceVariant,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? colors.onSurface : colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserAvatarCompact extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colors.surfaceVariant,
          child: Icon(Icons.person, size: 18, color: colors.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Guest',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, size: 20, color: colors.onSurfaceVariant),
          onPressed: () => context.go(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
}
