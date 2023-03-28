import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/music/Genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/view_model/music_swipe_view_model/music_swipe_view_model.dart';
import 'package:async/async.dart';

import '../../model/music_kit_api_arg/music_kit_api_arg.dart';

final currentMusicItemProvider = StateProvider<MusicItem?>((ref) => null);

final selectedGenreProvider = StateProvider<Genre?>((ref) => null);

final playedSecondProvider = StateProvider<double>((ref) => 0);


final musicItemListProvider = FutureProvider.family<List<MusicItem>, MusicKitApiArg>((ref, arg) async {
  // MusicSwipeViewModel vm = MusicSwipeViewModel();
  // return vm.getMusic(genreId);
  MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
  return musicKitApiRepository.getSongListData(arg.developerToken, arg.userToken, arg.genre);
});

final genreListProvider = FutureProvider.family<List<Genre>, MusicKitApiArg>((ref, arg) async {
  // MusicSwipeViewModel vm = MusicSwipeViewModel();
  // return vm.getMusic(genreId);
  MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
  return musicKitApiRepository.getGenre(arg.developerToken, arg.userToken);
});
