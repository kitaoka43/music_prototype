import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'like_music.freezed.dart';
part 'like_music.g.dart';

@freezed
class LikeMusic with _$LikeMusic {
  const factory LikeMusic({
    required String musicId,
    required String musicName,
    required String artistName,
    required String genre,
    required String genreName,
    required int durationInSec,
    required String artworkUrl,
    required DateTime createdAt,
  }) = _LikeMusic;

  factory LikeMusic.fromJson(Map<String, dynamic> json) =>
      _$LikeMusicFromJson(json);
}