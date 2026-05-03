import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../providers/player_provider.dart';
import 'blur_container.dart';

/// Mobile mini player displayed above the bottom tab bar.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerStatusProvider);
    final notifier = ref.read(playerNotifierProvider.notifier);
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return playerAsync.when(
      data: (status) {
        final track = status.currentTrack;
        if (track == null) return const SizedBox.shrink();

        final isPlaying = status.state.name == 'playing';

        return GestureDetector(
          onTap: () {
            // TODO: Open full-screen player page
          },
          child: BlurContainer(
            height: AppConstants.mobileMiniPlayerHeight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            blurSigma: 24,
            backgroundColor: colors.playerBarBg.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(color: colors.divider, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Artwork
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 44,
                      height: 44,
                      color: Colors.grey.shade800,
                      child: track.artworkUrl != null
                          ? Image.network(track.artworkUrl!, fit: BoxFit.cover)
                          : const Icon(Icons.music_note, color: Colors.white54, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          style: textStyles.playerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          track.artist,
                          style: textStyles.playerArtist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Controls
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: colors.onSurface,
                    ),
                    onPressed: isPlaying ? notifier.pause : notifier.play,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: colors.onSurfaceVariant),
                    onPressed: notifier.skipNext,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, st) => const SizedBox.shrink(),
    );
  }
}
