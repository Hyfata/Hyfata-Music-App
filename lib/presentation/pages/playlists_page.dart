import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../router/app_router.dart';

/// Playlists page displaying a grid of user playlists.
class PlaylistsPage extends ConsumerWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final isDesktop = context.screenWidth >= AppConstants.desktopBreakpoint;
    final crossAxisCount = isDesktop ? 4 : 2;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text('Playlists', style: textStyles.pageTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.go(AppRoutes.settings),
                ),
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
                child: Row(
                  children: [
                    Text('Playlists', style: textStyles.pageTitle),
                    const Spacer(),
                    _CreatePlaylistButton(colors: colors, textStyles: textStyles),
                    const SizedBox(width: 32),
                  ],
                ),
              ),
            ),
          if (!isDesktop)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _CreatePlaylistButton(colors: colors, textStyles: textStyles),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _mockPlaylists.length,
              itemBuilder: (context, index) {
                final playlist = _mockPlaylists[index];
                return _PlaylistGridCard(
                  title: playlist['title']!,
                  count: playlist['count']!,
                  colors: colors,
                  textStyles: textStyles,
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}

class _CreatePlaylistButton extends StatelessWidget {
  final AppColors colors;
  final AppTextStyles textStyles;

  const _CreatePlaylistButton({required this.colors, required this.textStyles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: Show create playlist dialog
        },
        icon: Icon(Icons.add, color: colors.onSurface),
        label: Text('New Playlist', style: textStyles.button),
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.onSurface,
          side: BorderSide(color: colors.divider),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
        ),
      ),
    );
  }
}

class _PlaylistGridCard extends StatelessWidget {
  final String title;
  final String count;
  final AppColors colors;
  final AppTextStyles textStyles;

  const _PlaylistGridCard({
    required this.title,
    required this.count,
    required this.colors,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.6),
                    colors.surfaceVariant,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.queue_music,
                  size: 48,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: textStyles.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(count, style: textStyles.caption),
      ],
    );
  }
}

final _mockPlaylists = [
  {'title': 'Liked Songs', 'count': '128 songs'},
  {'title': 'Driving', 'count': '45 songs'},
  {'title': 'Sleep', 'count': '32 songs'},
  {'title': 'Party', 'count': '67 songs'},
  {'title': 'Acoustic', 'count': '21 songs'},
  {'title': 'Indie Mix', 'count': '54 songs'},
];
