// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LikeMusic _$$_LikeMusicFromJson(Map<String, dynamic> json) => _$_LikeMusic(
      musicId: json['musicId'] as String,
      musicName: json['musicName'] as String,
      artistName: json['artistName'] as String,
      genre: json['genre'] as String,
      genreName: json['genreName'] as String,
      durationInSec: json['durationInSec'] as int,
      artworkUrl: json['artworkUrl'] as String,
      musicUrl: json['musicUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_LikeMusicToJson(_$_LikeMusic instance) =>
    <String, dynamic>{
      'musicId': instance.musicId,
      'musicName': instance.musicName,
      'artistName': instance.artistName,
      'genre': instance.genre,
      'genreName': instance.genreName,
      'durationInSec': instance.durationInSec,
      'artworkUrl': instance.artworkUrl,
      'musicUrl': instance.musicUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };
