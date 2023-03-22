import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post_music.freezed.dart';
part 'post_music.g.dart';

@freezed
class PostMusic with _$PostMusic {
  const factory PostMusic({
    required String musicId,
    required DateTime createdAt,
  }) = _PostMusic;

  factory PostMusic.fromJson(Map<String, dynamic> json) =>
      _$PostMusicFromJson(json);
}