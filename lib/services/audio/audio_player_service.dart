import 'dart:async';

import '../../domain/entities/track_entity.dart';

/// Playback states.
enum PlayerState { idle, loading, playing, paused, completed, error }

/// Simple data class for the current player state.
class PlayerStatus {
  final PlayerState state;
  final TrackEntity? currentTrack;
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isShuffleEnabled;
  final bool isRepeatEnabled;
  final String? errorMessage;

  const PlayerStatus({
    this.state = PlayerState.idle,
    this.currentTrack,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.isShuffleEnabled = false,
    this.isRepeatEnabled = false,
    this.errorMessage,
  });

  PlayerStatus copyWith({
    PlayerState? state,
    TrackEntity? currentTrack,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isShuffleEnabled,
    bool? isRepeatEnabled,
    String? errorMessage,
  }) {
    return PlayerStatus(
      state: state ?? this.state,
      currentTrack: currentTrack ?? this.currentTrack,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isShuffleEnabled: isShuffleEnabled ?? this.isShuffleEnabled,
      isRepeatEnabled: isRepeatEnabled ?? this.isRepeatEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Stub audio player service wrapping just_audio.
/// For now it emits mock data so the UI can be built.
class AudioPlayerService {
  final _controller = StreamController<PlayerStatus>.broadcast();
  PlayerStatus _status = const PlayerStatus();
  Timer? _positionTimer;

  AudioPlayerService() {
    _controller.add(_status);
  }

  Stream<PlayerStatus> get playerStateStream => _controller.stream;
  PlayerStatus get currentStatus => _status;

  Future<void> playTrack(TrackEntity track) async {
    _status = _status.copyWith(state: PlayerState.loading, currentTrack: track);
    _controller.add(_status);

    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 600));

    _status = _status.copyWith(
      state: PlayerState.playing,
      duration: const Duration(minutes: 3, seconds: 45),
      position: Duration.zero,
    );
    _controller.add(_status);
    _startPositionTimer();
  }

  Future<void> play() async {
    if (_status.currentTrack == null) return;
    _status = _status.copyWith(state: PlayerState.playing);
    _controller.add(_status);
    _startPositionTimer();
  }

  Future<void> pause() async {
    _status = _status.copyWith(state: PlayerState.paused);
    _controller.add(_status);
    _positionTimer?.cancel();
  }

  Future<void> seek(Duration position) async {
    _status = _status.copyWith(position: position);
    _controller.add(_status);
  }

  Future<void> setVolume(double volume) async {
    _status = _status.copyWith(volume: volume.clamp(0.0, 1.0));
    _controller.add(_status);
  }

  Future<void> skipNext() async {
    // TODO: implement queue logic
  }

  Future<void> skipPrevious() async {
    // TODO: implement queue logic
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_status.state != PlayerState.playing) return;
      final newPos = _status.position + const Duration(seconds: 1);
      if (newPos >= _status.duration) {
        _status = _status.copyWith(state: PlayerState.completed, position: _status.duration);
        _positionTimer?.cancel();
      } else {
        _status = _status.copyWith(position: newPos);
      }
      _controller.add(_status);
    });
  }

  void dispose() {
    _positionTimer?.cancel();
    _controller.close();
  }
}
