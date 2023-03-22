// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostMusic _$$_PostMusicFromJson(Map<String, dynamic> json) => _$_PostMusic(
      musicId: json['musicId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_PostMusicToJson(_$_PostMusic instance) =>
    <String, dynamic>{
      'musicId': instance.musicId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
