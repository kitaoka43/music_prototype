import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';

final apiUriBase = Provider<String>((ref) {
  return "api.music.apple.com";
});

final apiUriSearch = Provider<String>((ref) {
  return "/v1/catalog/jp/charts";
});

final apiHeader = StateProvider<Map<String, String>>((ref) {
  Map<String, String> headers = {"Authorization": 'Bearer developerToken', "Music-User-Token": 'userToken'};
  return headers;
});

final developerTokenProvider = StateProvider<String>((ref) {
  return "developerToken";
});

final userTokenProvider = StateProvider<String>((ref) {
  return "userToken";
});

final musicKitProvider = StateProvider<MusicKit>((ref) => MusicKit());

