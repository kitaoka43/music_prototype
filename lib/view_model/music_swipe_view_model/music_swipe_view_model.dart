import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_kit/music_kit.dart';
import 'package:music_prototype/model/music/Genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/repository/musik_kit_api_repository/music_kit_api_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:music_prototype/state/common/swipe_state.dart';

class MusicSwipeViewModel {
  late WidgetRef ref;
  late MusicKitApiRepository musicKitApiRepository;
  setRef(WidgetRef ref){
    this.ref = ref;
    musicKitApiRepository = MusicKitApiRepository();
  }

  // 曲再生
  void musicPlay() async{
    MusicItem? musicItem = ref.watch(currentMusicItemProvider);
    if (musicItem == null){
      return;
    }

    MusicKit musicKit = ref.watch(musicKitProvider);
    await musicKit.setQueue("songs", item: musicItem.toItem());
    await musicKit.play();
  }
  // 曲ストップ
  void musicStop(){
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
  Future<List<Genre>> getGenre(){
    String developerToken = ref.watch(developerTokenProvider);
    String userToken = ref.watch(userTokenProvider);
    MusicKitApiRepository musicKitApiRepository = MusicKitApiRepository();
    return musicKitApiRepository.getGenre(developerToken, userToken);
  }

  //like時の処理
  void swipeLike(MusicItem musicItem){
    ref.watch(currentMusicItemProvider.notifier).state = musicItem;
    musicPlay();
  }

  //bad時の処理
  void swipeBad(MusicItem musicItem){
    ref.watch(currentMusicItemProvider.notifier).state = musicItem;
    musicPlay();
  }


}
