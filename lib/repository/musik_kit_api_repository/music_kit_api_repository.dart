import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/model/post_music/post_music.dart';
import 'package:music_prototype/repository/post_music_repository/post_music_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:http/http.dart' as http;

class MusicKitApiRepository {
  late WidgetRef ref;
  // String developerToken = "";
  // String userToken = "";

  MusicKitApiRepository({required this.ref});

  // 曲情報リスト取得
  Future<List<MusicItem>> getSongListData(int genre) async {
    String uriBase = ref.read(apiUriBase);
    String uriSearch = ref.read(apiUriSearch);
    // Map<String, String> headers = ref.read(apiHeader);

    String developerToken = ref.watch(developerTokenProvider);
    String userToken = ref.watch(userTokenProvider);

    // ヘッダーにdeveloperTokenとuserTokenを設定する
    Map<String, String> headers = {"Authorization": 'Bearer $developerToken', "Music-User-Token": userToken};
    // URLの設定
    Uri url = Uri.https('api.music.apple.com', '/v1/catalog/jp/charts', {'genre': '$genre', 'types': 'songs'});
    // print(url.toString());
    // print(developerToken.toString());
    // print(userToken.toString());
    // HTTPSリクエスト実行
    var response = await http.get(url, headers: headers);

    // レスポンス結果をつめる
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // リストの生成
    List<MusicItem> result = [];
    // 過去の情報を取得
    List<PostMusic> postMusicList = await PostMusicRepository.getPostMusic();
    for (Map<String, dynamic> data in jsonResponse["results"]["songs"][0]["data"]) {
      MusicItem musicItem = MusicItem.createMusicItem(data);
      // 過去の情報に存在する場合、リストから削除
      bool isExist = false;
      for (PostMusic postMusic in postMusicList) {
        if (postMusic.musicId == musicItem.id) {
          isExist = true;
        }
      }
      if (isExist == false) {
        result.add(musicItem);
      }
    }
    return result;
  }

  // 1曲取得
  Future<MusicItem> getSongData(String genre) async {
    String uriBase = ref.read(apiUriBase);
    String uriSearch = ref.read(apiUriSearch);
    // Map<String, String> headers = ref.read(apiHeader);

    String developerToken = ref.watch(developerTokenProvider);
    String userToken = ref.watch(userTokenProvider);

    // ヘッダーにdeveloperTokenとuserTokenを設定する
    Map<String, String> headers = {"Authorization": 'Bearer $developerToken', "Music-User-Token": "userToken"};
    // URLの設定
    Uri url = Uri.https('api.music.apple.com', '/v1/catalog/jp/charts', {'genre': genre, 'types': 'songs'});
    // HTTPSリクエスト実行
    var response = await http.get(url, headers: headers);
    // print(response.headers);

    // レスポンス結果をつめる
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    MusicItem result = MusicItem.createMusicItem(jsonResponse["results"]["songs"]["data"][0]);
    return result;
  }
}
