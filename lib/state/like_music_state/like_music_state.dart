import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/model/music/Genre.dart';
import 'package:music_prototype/repository/like_music_repository/like_music_repository.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';

// 保存されている音楽のリスト
final likeMusicItemListProvider = FutureProvider<List<LikeMusic>>((ref) async {
  final genre = ref.watch(selectedLikeGenreProvider);
  if (genre == null){
    return [];
  }
  return LikeMusicRepository.getLikeMusicListByGenre(genre.id);
});

// 保存されている音楽のジャンルリスト
final likeGenreListProvider = FutureProvider<List<Genre>>((ref) {
  // MusicSwipeViewModel vm = MusicSwipeViewModel();
  // return vm.getMusic(genreId);
  return LikeMusicRepository.getLikeMusicGenreList();
});

// ジャンル選択
final selectedLikeGenreProvider = StateProvider<Genre?>((ref) => null);
final beforeSelectedLikeGenreProvider = StateProvider<Genre?>((ref) => null);