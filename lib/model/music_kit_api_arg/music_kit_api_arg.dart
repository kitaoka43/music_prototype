import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'music_kit_api_arg.freezed.dart';
part 'music_kit_api_arg.g.dart';

@freezed
class MusicKitApiArg with _$MusicKitApiArg {
  const factory MusicKitApiArg({
    required String developerToken,
    required String userToken,
    required int genre,
  }) = _MusicKitApiArg;

  factory MusicKitApiArg.fromJson(Map<String, dynamic> json) =>
      _$MusicKitApiArgFromJson(json);
}