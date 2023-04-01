import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/model/music/genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/model/post_music/post_music.dart';
import 'package:music_prototype/repository/like_music_repository/like_music_repository.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/repository/post_music_repository/post_music_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:music_prototype/state/common/swipe_state.dart';
import 'package:music_prototype/state/like_music_state/like_music_state.dart';

class MusicSwipeViewModel {
  late WidgetRef ref;
  late MusicKitApiRepository musicKitApiRepository;

  setRef(WidgetRef ref) {
    this.ref = ref;
    musicKitApiRepository = MusicKitApiRepository();
  }

  // 曲再生
  void musicPlay(MusicKit musicKit) async {
    // 現在の曲を取得
    MusicItem? musicItem = ref.watch(currentMusicItemProvider);
    if (musicItem == null) {
      return;
    }

    // 曲を再生する
    await musicKit.setQueue("songs", item: musicItem.toItem());
    await musicKit.prepareToPlay();
    await musicKit.play();
  }

  // 曲ストップ
  void musicStop(MusicKit musicKit) {
    MusicKit musicKit = ref.watch(musicKitProvider);
    musicKit.pause();
  }

  // 初期処理
  void initProcess() async {
    // ジャンルの取得
    // List<Genre> genreList =  await _getGenre();
    // List<MusicItem> musicItemList = await _getMusic(int.parse(genreList[0].id));

    // 状態管理
    // ref.watch(musicItemListProvider) = _getMusic(int.parse(genreList[0].id));
  }

  //表示するための曲リスト取得
  Future<List<MusicItem>> getMusic(int genre) async {
    String developerToken = ref.watch(developerTokenProvider);
    String userToken = ref.watch(userTokenProvider);
    MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
    return musicKitApiRepository.getSongListData(developerToken, userToken, genre);
  }

  // ドロップダウンボックス取得
  Future<List<Genre>> getGenre() {
    String developerToken = ref.watch(developerTokenProvider);
    String userToken = ref.watch(userTokenProvider);
    MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
    return musicKitApiRepository.getGenre(developerToken, userToken);
  }

  //like時の処理
  Future<bool> swipeLike(MusicItem musicItem, MusicItem nextMusicItem) async {
    // 次の曲を設定する
    ref.watch(currentMusicItemProvider.notifier).state = nextMusicItem;
    Genre genre = ref.read(selectedGenreProvider)!;

    // LikeMusicテーブルに保存
    LikeMusic likeMusic = LikeMusic(
        musicId: musicItem.id,
        musicName: musicItem.musicName,
        artistName: musicItem.artistName,
        genre: genre.id,
        genreName: genre.attributes["name"] ?? "",
        artworkUrl: musicItem.artworkUrl,
        createdAt: DateTime.now());
    LikeMusicRepository.insertLikeMusic(likeMusic);

    // PostMusicに保存
    PostMusic postMusic = PostMusic(musicId: musicItem.id, createdAt: DateTime.now());
    await PostMusicRepository.insertPostMusic(postMusic);

    ref.refresh(likeMusicItemListProvider);

    return true;
  }

  //bad時の処理
  Future<bool> swipeBad(MusicItem musicItem, MusicItem nextMusicItem) async {
    // 次の曲を設定する
    ref.watch(currentMusicItemProvider.notifier).state = nextMusicItem;

    // PostMusicに保存
    PostMusic postMusic = PostMusic(musicId: musicItem.id, createdAt: DateTime.now());
    await PostMusicRepository.insertPostMusic(postMusic);

    return true;
  }

  //bad時の処理
  bool isStop(MusicPlayerPlaybackStatus status) {
    if (status == MusicPlayerPlaybackStatus.paused ||
        status == MusicPlayerPlaybackStatus.stopped ||
        status == MusicPlayerPlaybackStatus.interrupted) {
      return true;
    }
    return false;
  }
}
