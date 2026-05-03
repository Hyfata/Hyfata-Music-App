import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/track_entity.dart';
import '../providers/player_provider.dart';
import '../router/app_router.dart';

/// Home page displaying frequent playlists and recently played tracks.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final isDesktop = context.screenWidth >= AppConstants.desktopBreakpoint;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text('Home', style: textStyles.pageTitle),
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
                padding: const EdgeInsets.only(left: 32, top: 32, bottom: 8),
                child: Text('Home', style: textStyles.pageTitle),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              child: Text('Frequent Playlists', style: textStyles.sectionHeader),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppConstants.artworkLarge + 64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _mockPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = _mockPlaylists[index];
                  return _PlaylistCard(
                    title: playlist['title']!,
                    subtitle: playlist['subtitle']!,
                    colors: colors,
                    textStyles: textStyles,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
              child: Text('Recently Played', style: textStyles.sectionHeader),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: _mockRecentTracks.length,
              itemBuilder: (context, index) {
                final track = _mockRecentTracks[index];
                return _RecentTrackTile(
                  track: track,
                  colors: colors,
                  textStyles: textStyles,
                  onTap: () {
                    ref.read(playerNotifierProvider.notifier).playTrack(track);
                  },
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

class _PlaylistCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppColors colors;
  final AppTextStyles textStyles;

  const _PlaylistCard({
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: Container(
              width: AppConstants.artworkLarge,
              height: AppConstants.artworkLarge,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.8),
                    colors.primaryVariant.withValues(alpha: 0.9),
                  ],
                ),
              ),
              child: Center(
                child: Icon(Icons.music_note, size: 48, color: colors.onPrimary.withValues(alpha: 0.8)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: AppConstants.artworkLarge,
            child: Text(
              title,
              style: textStyles.cardTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: AppConstants.artworkLarge,
            child: Text(
              subtitle,
              style: textStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTrackTile extends StatelessWidget {
  final TrackEntity track;
  final AppColors colors;
  final AppTextStyles textStyles;
  final VoidCallback onTap;

  const _RecentTrackTile({
    required this.track,
    required this.colors,
    required this.textStyles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              child: Container(
                width: AppConstants.artworkSmall,
                height: AppConstants.artworkSmall,
                color: colors.surfaceVariant,
                child: track.artworkUrl != null
                    ? Image.network(track.artworkUrl!, fit: BoxFit.cover)
                    : Icon(Icons.music_note, color: colors.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(track.title, style: textStyles.trackTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(track.artist, style: textStyles.trackArtist, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: colors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

final _mockPlaylists = [
  {'title': 'Chill Vibes', 'subtitle': 'Curated by Hyfata'},
  {'title': 'Late Night', 'subtitle': 'Curated by Hyfata'},
  {'title': 'Workout Mix', 'subtitle': 'Curated by Hyfata'},
  {'title': 'Focus Flow', 'subtitle': 'Curated by Hyfata'},
];

final _mockRecentTracks = [
  const TrackEntity(id: '1', title: 'Midnight City', artist: 'M83', album: 'Hurry Up, We\'re Dreaming'),
  const TrackEntity(id: '2', title: 'Blinding Lights', artist: 'The Weeknd', album: 'After Hours'),
  const TrackEntity(id: '3', title: 'Levitating', artist: 'Dua Lipa', album: 'Future Nostalgia'),
  const TrackEntity(id: '4', title: 'Heat Waves', artist: 'Glass Animals', album: 'Dreamland'),
  const TrackEntity(id: '5', title: 'Stay', artist: 'The Kid LAROI & Justin Bieber', album: 'F*CK LOVE 3'),
];
