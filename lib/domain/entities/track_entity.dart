/// Represents a single music track in the domain layer.
class TrackEntity {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final Duration? duration;
  final String? artworkUrl;
  final String? localPath;
  final String? youtubeId;
  final String? soundcloudId;
  final String? isrc;
  final double? lufs;
  final DateTime? lastPlayedAt;

  const TrackEntity({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.duration,
    this.artworkUrl,
    this.localPath,
    this.youtubeId,
    this.soundcloudId,
    this.isrc,
    this.lufs,
    this.lastPlayedAt,
  });

  TrackEntity copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    Duration? duration,
    String? artworkUrl,
    String? localPath,
    String? youtubeId,
    String? soundcloudId,
    String? isrc,
    double? lufs,
    DateTime? lastPlayedAt,
  }) {
    return TrackEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      localPath: localPath ?? this.localPath,
      youtubeId: youtubeId ?? this.youtubeId,
      soundcloudId: soundcloudId ?? this.soundcloudId,
      isrc: isrc ?? this.isrc,
      lufs: lufs ?? this.lufs,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }
}
