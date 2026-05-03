import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/track_entity.dart';
import '../../services/audio/audio_player_service.dart';

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});

final playerStatusProvider = StreamProvider<PlayerStatus>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.playerStateStream;
});

final playerStatusSyncProvider = Provider<PlayerStatus>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return service.currentStatus;
});

class PlayerNotifier extends StateNotifier<AsyncValue<PlayerStatus>> {
  final AudioPlayerService _service;

  PlayerNotifier(this._service) : super(const AsyncValue.loading()) {
    _service.playerStateStream.listen((status) {
      state = AsyncValue.data(status);
    }, onError: (err, st) {
      state = AsyncValue.error(err, st);
    });
  }

  Future<void> playTrack(TrackEntity track) => _service.playTrack(track);
  Future<void> play() => _service.play();
  Future<void> pause() => _service.pause();
  Future<void> seek(Duration position) => _service.seek(position);
  Future<void> setVolume(double volume) => _service.setVolume(volume);
  Future<void> skipNext() => _service.skipNext();
  Future<void> skipPrevious() => _service.skipPrevious();
}

final playerNotifierProvider = StateNotifierProvider<PlayerNotifier, AsyncValue<PlayerStatus>>((ref) {
  final service = ref.watch(audioPlayerServiceProvider);
  return PlayerNotifier(service);
});
