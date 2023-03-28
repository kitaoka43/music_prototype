import 'dart:convert';
import 'package:async/async.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_prototype/model/music/Genre.dart';
import 'package:music_prototype/model/music/music_item.dart';
import 'package:music_prototype/model/post_music/post_music.dart';
import 'package:music_prototype/repository/post_music_repository/post_music_repository.dart';
import 'package:music_prototype/state/common/music_kit_api.dart';
import 'package:http/http.dart' as http;

class MusicKitApiRepository {
  MusicKitApiRepository();

  // 曲情報リスト取得
  Future<List<MusicItem>> getSongListData(String developerToken, String userToken, int genre) async {
    List<MusicItem> result = [];
    final AsyncMemoizer memoizer = AsyncMemoizer();
    await memoizer.runOnce(() async {
      // ヘッダーにdeveloperTokenとuserTokenを設定する
      Map<String, String> headers = {"Authorization": 'Bearer $developerToken', "Music-User-Token": userToken};
      // URLの設定
      Uri url = Uri.https('api.music.apple.com', '/v1/catalog/jp/charts', {'genre': '$genre', 'types': 'songs', 'limit': '200'});
      // HTTPSリクエスト実行
      var response = await http.get(url, headers: headers);

      // レスポンス結果をつめる
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // リストの生成
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
    });
    return result;

  }

  // 1曲取得
  Future<MusicItem> getSongData(String developerToken, String userToken, int genre) async {
    MusicItem result = MusicItem("id", "type", {}, 0, "artworkUrl", "musicName", "artistName");
    final AsyncMemoizer memoizer = AsyncMemoizer();
    await memoizer.runOnce(() async {
      // ヘッダーにdeveloperTokenとuserTokenを設定する
      Map<String, String> headers = {"Authorization": 'Bearer $developerToken', "Music-User-Token": "userToken"};
      // URLの設定
      Uri url = Uri.https('api.music.apple.com', '/v1/catalog/jp/charts', {'genre': genre, 'types': 'songs'});
      // HTTPSリクエスト実行
      var response = await http.get(url, headers: headers);
      // print(response.headers);

      // レスポンス結果をつめる
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      result = MusicItem.createMusicItem(jsonResponse["results"]["songs"]["data"][0]);
    });
    return result;
  }

  // ジャンル取得
  Future<List<Genre>> getGenre(String developerToken, String userToken) async {
    List<Genre> result = List.empty();
    final AsyncMemoizer memoizer = AsyncMemoizer();
    await memoizer.runOnce(() async {
      // ヘッダーにdeveloperTokenとuserTokenを設定する
      Map<String, String> headers = {"Authorization": 'Bearer $developerToken', "Music-User-Token": userToken};
      // URLの設定
      Uri url = Uri.https('api.music.apple.com', '/v1/catalog/jp/genres');
      // HTTPSリクエスト実行
      var response = await http.get(url, headers: headers);

      // レスポンス結果をつめる
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // リストの生成
      result = Genre.createGenreList(jsonResponse["data"]);
    });
    return result;
  }
}
