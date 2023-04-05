import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/model/music/genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/model/music_kit_api_arg/music_kit_api_arg.dart';
import 'package:music_prototype/model/post_music/post_music.dart';
import 'package:music_prototype/repository/like_music_repository/like_music_repository.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/repository/post_music_repository/post_music_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:music_prototype/state/common/music_playing_state.dart';
import 'package:music_prototype/state/common/swipe_state.dart';
import 'package:music_prototype/state/like_music_state/like_music_state.dart';

class MusicPlayingViewModel {
  late WidgetRef ref;
  late MusicKit musicKit;

  setRef(WidgetRef ref, MusicKit musicKit) {
    this.ref = ref;
    this.musicKit = musicKit;
  }

  // 次の曲を流す
  Future<bool> nextMusicPlay() async {
    int currentIndex = ref.watch(musicPlayingCurrentMusicItemIndexProvider);
    List<LikeMusic> musicList = ref.watch(musicPlayingCurrentMusicItemListProvider);

    // musicListの最後の曲の場合
    if (musicList.isNotEmpty && musicList.length - 1 < currentIndex) {
      // 音楽を止めて、始めの曲をセットする
      musicKit.setQueue("songs", item: musicList[0].toJson());
      musicKit.prepareToPlay();
      return false;
    }

    await musicKit.setQueue("songs", item: musicList[currentIndex + 1].toJson());
    await musicKit.play();
    return true;
  }

  // 前の曲を流す
  Future<bool> backMusicPlay() async {
    int currentIndex = ref.watch(musicPlayingCurrentMusicItemIndexProvider);
    List<LikeMusic> musicList = ref.watch(musicPlayingCurrentMusicItemListProvider);

    // musicListの最後の曲の場合
    if (musicList.isNotEmpty && currentIndex == 0) {
      // 音楽を止める
      musicKit.prepareToPlay();
      return false;
    }

    await musicKit.setQueue("songs", item: MusicItem.likeMusicToItem(musicList[currentIndex - 1]));
    await musicKit.play();
    return true;
  }

  // 曲再生
  Future<bool> musicPlay() async {
    // 現在の曲を取得
    LikeMusic? currentMusic = ref.watch(musicPlayingCurrentMusicItemProvider);

    if (currentMusic == null) {
      return false;
    } else {
      // 曲を再生する
      await musicKit.stop();
      await musicKit.setQueue("songs", item: MusicItem.likeMusicToItem(currentMusic));
      await musicKit.play();
      return true;
    }
  }

  // 曲ストップ
  Future<bool> musicStop(MusicKit musicKit) async {
    // 現在の曲を取得
    LikeMusic? currentMusic = ref.watch(musicPlayingCurrentMusicItemProvider);

    if (currentMusic == null) {
      return false;
    } else {
      // 曲を再生する
      await musicKit.stop();
      return true;
    }
  }
}
