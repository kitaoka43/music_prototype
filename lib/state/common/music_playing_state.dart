// 現在流れている音楽
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/model/music/music_item.dart';

// 現在流れている音楽
final musicPlayingCurrentMusicItemProvider = StateProvider<LikeMusic?>((ref) => null);
final musicPlayingCurrentMusicItemIndexProvider = StateProvider<int>((ref) => 0);

// 現在流れている音楽
final musicPlayingCurrentMusicItemListProvider = StateProvider<List<LikeMusic>>((ref) => []);