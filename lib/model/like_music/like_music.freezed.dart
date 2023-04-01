// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_music.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LikeMusic _$LikeMusicFromJson(Map<String, dynamic> json) {
  return _LikeMusic.fromJson(json);
}

/// @nodoc
mixin _$LikeMusic {
  String get musicId => throw _privateConstructorUsedError;
  String get musicName => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  String get genreName => throw _privateConstructorUsedError;
  String get artworkUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikeMusicCopyWith<LikeMusic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeMusicCopyWith<$Res> {
  factory $LikeMusicCopyWith(LikeMusic value, $Res Function(LikeMusic) then) =
      _$LikeMusicCopyWithImpl<$Res, LikeMusic>;
  @useResult
  $Res call(
      {String musicId,
      String musicName,
      String artistName,
      String genre,
      String genreName,
      String artworkUrl,
      DateTime createdAt});
}

/// @nodoc
class _$LikeMusicCopyWithImpl<$Res, $Val extends LikeMusic>
    implements $LikeMusicCopyWith<$Res> {
  _$LikeMusicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicId = null,
    Object? musicName = null,
    Object? artistName = null,
    Object? genre = null,
    Object? genreName = null,
    Object? artworkUrl = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      musicId: null == musicId
          ? _value.musicId
          : musicId // ignore: cast_nullable_to_non_nullable
              as String,
      musicName: null == musicName
          ? _value.musicName
          : musicName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      genreName: null == genreName
          ? _value.genreName
          : genreName // ignore: cast_nullable_to_non_nullable
              as String,
      artworkUrl: null == artworkUrl
          ? _value.artworkUrl
          : artworkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LikeMusicCopyWith<$Res> implements $LikeMusicCopyWith<$Res> {
  factory _$$_LikeMusicCopyWith(
          _$_LikeMusic value, $Res Function(_$_LikeMusic) then) =
      __$$_LikeMusicCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String musicId,
      String musicName,
      String artistName,
      String genre,
      String genreName,
      String artworkUrl,
      DateTime createdAt});
}

/// @nodoc
class __$$_LikeMusicCopyWithImpl<$Res>
    extends _$LikeMusicCopyWithImpl<$Res, _$_LikeMusic>
    implements _$$_LikeMusicCopyWith<$Res> {
  __$$_LikeMusicCopyWithImpl(
      _$_LikeMusic _value, $Res Function(_$_LikeMusic) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicId = null,
    Object? musicName = null,
    Object? artistName = null,
    Object? genre = null,
    Object? genreName = null,
    Object? artworkUrl = null,
    Object? createdAt = null,
  }) {
    return _then(_$_LikeMusic(
      musicId: null == musicId
          ? _value.musicId
          : musicId // ignore: cast_nullable_to_non_nullable
              as String,
      musicName: null == musicName
          ? _value.musicName
          : musicName // ignore: cast_nullable_to_non_nullable
              as String,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      genreName: null == genreName
          ? _value.genreName
          : genreName // ignore: cast_nullable_to_non_nullable
              as String,
      artworkUrl: null == artworkUrl
          ? _value.artworkUrl
          : artworkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikeMusic with DiagnosticableTreeMixin implements _LikeMusic {
  const _$_LikeMusic(
      {required this.musicId,
      required this.musicName,
      required this.artistName,
      required this.genre,
      required this.genreName,
      required this.artworkUrl,
      required this.createdAt});

  factory _$_LikeMusic.fromJson(Map<String, dynamic> json) =>
      _$$_LikeMusicFromJson(json);

  @override
  final String musicId;
  @override
  final String musicName;
  @override
  final String artistName;
  @override
  final String genre;
  @override
  final String genreName;
  @override
  final String artworkUrl;
  @override
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LikeMusic(musicId: $musicId, musicName: $musicName, artistName: $artistName, genre: $genre, genreName: $genreName, artworkUrl: $artworkUrl, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LikeMusic'))
      ..add(DiagnosticsProperty('musicId', musicId))
      ..add(DiagnosticsProperty('musicName', musicName))
      ..add(DiagnosticsProperty('artistName', artistName))
      ..add(DiagnosticsProperty('genre', genre))
      ..add(DiagnosticsProperty('genreName', genreName))
      ..add(DiagnosticsProperty('artworkUrl', artworkUrl))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikeMusic &&
            (identical(other.musicId, musicId) || other.musicId == musicId) &&
            (identical(other.musicName, musicName) ||
                other.musicName == musicName) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.genreName, genreName) ||
                other.genreName == genreName) &&
            (identical(other.artworkUrl, artworkUrl) ||
                other.artworkUrl == artworkUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, musicId, musicName, artistName,
      genre, genreName, artworkUrl, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LikeMusicCopyWith<_$_LikeMusic> get copyWith =>
      __$$_LikeMusicCopyWithImpl<_$_LikeMusic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikeMusicToJson(
      this,
    );
  }
}

abstract class _LikeMusic implements LikeMusic {
  const factory _LikeMusic(
      {required final String musicId,
      required final String musicName,
      required final String artistName,
      required final String genre,
      required final String genreName,
      required final String artworkUrl,
      required final DateTime createdAt}) = _$_LikeMusic;

  factory _LikeMusic.fromJson(Map<String, dynamic> json) =
      _$_LikeMusic.fromJson;

  @override
  String get musicId;
  @override
  String get musicName;
  @override
  String get artistName;
  @override
  String get genre;
  @override
  String get genreName;
  @override
  String get artworkUrl;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_LikeMusicCopyWith<_$_LikeMusic> get copyWith =>
      throw _privateConstructorUsedError;
}
