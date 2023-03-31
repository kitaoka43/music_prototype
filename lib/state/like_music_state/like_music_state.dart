import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/repository/like_music_repository/like_music_repository.dart';

// 保存されている音楽のリスト
final musicItemListProvider = FutureProvider.family<List<LikeMusic>, String>((ref, genre) async {
  return LikeMusicRepository.getLikeMusicListByGenre(genre);
});