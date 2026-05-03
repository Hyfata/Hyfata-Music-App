import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/track_entity.dart';
import '../../services/audio/audio_player_service.dart';
import '../providers/player_provider.dart';
import 'blur_container.dart';

/// Desktop player bar displayed at the top of the screen.
/// Shows current track info, playback controls, and volume.
class PlayerBar extends ConsumerWidget {
  const PlayerBar({super.key});

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

        return BlurContainer(
          height: AppConstants.desktopPlayerBarHeight,
          borderRadius: BorderRadius.zero,
          blurSigma: 30,
          backgroundColor: colors.playerBarBg.withValues(alpha: 0.85),
          border: Border(
            bottom: BorderSide(color: colors.divider, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Artwork + Track info
                TrackInfo(track: track, textStyles: textStyles),
                const SizedBox(width: 24),
                // Controls
                PlaybackControls(
                  isPlaying: isPlaying,
                  status: status,
                  notifier: notifier,
                  colors: colors,
                ),
                const Spacer(),
                // Volume
                VolumeControl(
                  volume: status.volume,
                  notifier: notifier,
                  colors: colors,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, st) => const SizedBox.shrink(),
    );
  }
}

class TrackInfo extends StatelessWidget {
  final TrackEntity track;
  final AppTextStyles textStyles;

  const TrackInfo({super.key, required this.track, required this.textStyles});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 48,
            height: 48,
            color: Colors.grey.shade800,
            child: track.artworkUrl != null
                ? Image.network(track.artworkUrl!, fit: BoxFit.cover)
                : const Icon(Icons.music_note, color: Colors.white54),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(track.title, style: textStyles.playerTitle),
            Text(track.artist, style: textStyles.playerArtist),
          ],
        ),
      ],
    );
  }
}

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final PlayerStatus status;
  final PlayerNotifier notifier;
  final AppColors colors;

  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.status,
    required this.notifier,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous, color: colors.onSurface),
          onPressed: notifier.skipPrevious,
        ),
        IconButton(
          iconSize: 36,
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: colors.onSurface,
          ),
          onPressed: isPlaying ? notifier.pause : notifier.play,
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: colors.onSurface),
          onPressed: notifier.skipNext,
        ),
        const SizedBox(width: 16),
        // Progress
        SizedBox(
          width: 200,
          child: Slider(
            value: status.position.inMilliseconds.toDouble(),
            max: status.duration.inMilliseconds.toDouble().clamp(1, double.infinity),
            onChanged: (value) => notifier.seek(Duration(milliseconds: value.toInt())),
          ),
        ),
        Text(
          _formatDuration(status.position),
          style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
        ),
        Text(' / ', style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant)),
        Text(
          _formatDuration(status.duration),
          style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class VolumeControl extends StatelessWidget {
  final double volume;
  final PlayerNotifier notifier;
  final AppColors colors;

  const VolumeControl({
    super.key,
    required this.volume,
    required this.notifier,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          volume == 0
              ? Icons.volume_off
              : volume < 0.5
                  ? Icons.volume_down
                  : Icons.volume_up,
          color: colors.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(
          width: 100,
          child: Slider(
            value: volume,
            onChanged: notifier.setVolume,
          ),
        ),
      ],
    );
  }
}
