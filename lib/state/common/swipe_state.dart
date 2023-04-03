import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/music/genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/view_model/music_swipe_view_model/music_swipe_view_model.dart';
import 'package:async/async.dart';

import '../../model/music_kit_api_arg/music_kit_api_arg.dart';

// 現在流れている音楽
final currentMusicItemProvider = StateProvider<MusicItem?>((ref) => null);

// ジャンル選択
final selectedGenreProvider = StateProvider<Genre?>((ref) => null);
final beforeSelectedGenreProvider = StateProvider<Genre?>((ref) => null);


final playedSecondProvider = StateProvider<double>((ref) => 0);

// APIで取得してきた音楽のリスト
final musicItemListProvider = FutureProvider.family<List<MusicItem>, MusicKitApiArg>((ref, arg) async {
  // MusicSwipeViewModel vm = MusicSwipeViewModel();
  // return vm.getMusic(genreId);
  MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
  return musicKitApiRepository.getSongListData(arg.developerToken, arg.userToken, arg.genre);
});

// APIで取得してきたジャンルのリスト
final genreListProvider = FutureProvider.family<List<Genre>, MusicKitApiArg>((ref, arg) async {
  // MusicSwipeViewModel vm = MusicSwipeViewModel();
  // return vm.getMusic(genreId);
  MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
  return musicKitApiRepository.getGenre(arg.developerToken, arg.userToken);
});

// 現在流れている音楽
final currentMusicItemBKProvider = StateProvider<MusicItem?>((ref) => null);
