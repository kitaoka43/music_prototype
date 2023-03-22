// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_music.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PostMusic _$PostMusicFromJson(Map<String, dynamic> json) {
  return _PostMusic.fromJson(json);
}

/// @nodoc
mixin _$PostMusic {
  String get musicId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostMusicCopyWith<PostMusic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostMusicCopyWith<$Res> {
  factory $PostMusicCopyWith(PostMusic value, $Res Function(PostMusic) then) =
      _$PostMusicCopyWithImpl<$Res, PostMusic>;
  @useResult
  $Res call({String musicId, DateTime createdAt});
}

/// @nodoc
class _$PostMusicCopyWithImpl<$Res, $Val extends PostMusic>
    implements $PostMusicCopyWith<$Res> {
  _$PostMusicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicId = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      musicId: null == musicId
          ? _value.musicId
          : musicId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PostMusicCopyWith<$Res> implements $PostMusicCopyWith<$Res> {
  factory _$$_PostMusicCopyWith(
          _$_PostMusic value, $Res Function(_$_PostMusic) then) =
      __$$_PostMusicCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String musicId, DateTime createdAt});
}

/// @nodoc
class __$$_PostMusicCopyWithImpl<$Res>
    extends _$PostMusicCopyWithImpl<$Res, _$_PostMusic>
    implements _$$_PostMusicCopyWith<$Res> {
  __$$_PostMusicCopyWithImpl(
      _$_PostMusic _value, $Res Function(_$_PostMusic) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicId = null,
    Object? createdAt = null,
  }) {
    return _then(_$_PostMusic(
      musicId: null == musicId
          ? _value.musicId
          : musicId // ignore: cast_nullable_to_non_nullable
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
class _$_PostMusic with DiagnosticableTreeMixin implements _PostMusic {
  const _$_PostMusic({required this.musicId, required this.createdAt});

  factory _$_PostMusic.fromJson(Map<String, dynamic> json) =>
      _$$_PostMusicFromJson(json);

  @override
  final String musicId;
  @override
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostMusic(musicId: $musicId, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostMusic'))
      ..add(DiagnosticsProperty('musicId', musicId))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PostMusic &&
            (identical(other.musicId, musicId) || other.musicId == musicId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, musicId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PostMusicCopyWith<_$_PostMusic> get copyWith =>
      __$$_PostMusicCopyWithImpl<_$_PostMusic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostMusicToJson(
      this,
    );
  }
}

abstract class _PostMusic implements PostMusic {
  const factory _PostMusic(
      {required final String musicId,
      required final DateTime createdAt}) = _$_PostMusic;

  factory _PostMusic.fromJson(Map<String, dynamic> json) =
      _$_PostMusic.fromJson;

  @override
  String get musicId;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_PostMusicCopyWith<_$_PostMusic> get copyWith =>
      throw _privateConstructorUsedError;
}
