import 'package:music_prototype/model/like_music/like_music.dart';

class MusicItem {
  String id;
  String type;
  Map<String, Map<String, String>> attributes;
  int durationInSec;
  String artworkUrl;
  String musicUrl;
  String musicName;
  String artistName;

  MusicItem(this.id, this.type, this.attributes, this.durationInSec, this.artworkUrl, this.musicUrl, this.musicName, this.artistName);

  // Musicアイテム生成
  static MusicItem createMusicItem(Map<String, dynamic> data){
    String id = data["id"];
    String type = data["type"];
    int durationInSec = (data["attributes"]["durationInMillis"]).toInt();
    String artworkUrl = data["attributes"]["artwork"]["url"];
    String musicUrl = data["attributes"]["url"];
    if (artworkUrl.isNotEmpty){
      artworkUrl = artworkUrl.replaceFirst("{w}", "1000").replaceFirst("{h}", "1000");
    }
    String musicName = data["attributes"]["name"];
    String artistName = data["attributes"]["artistName"];
    Map<String, String> playParams = {"id" : data["attributes"]["playParams"]["id"], "kind":  data["attributes"]["playParams"]["kind"]};
    Map<String, Map<String, String>> attributes = {"playParams":playParams};
    MusicItem musicItem = MusicItem(id, type, attributes, durationInSec, artworkUrl, musicUrl, musicName, artistName);
    return musicItem;
  }
  // Musicアイテム（再生時）変換
  Map<String,dynamic> toItem(){
    Map<String,dynamic> result = {};
    result["id"] = id;
    result["type"] = type;
    Map<String,dynamic> playParams = {};
    playParams["id"] = id;
    playParams["kind"] = "song";
    Map<String,dynamic> attributes = {};
    attributes["playParams"] = playParams;
    result["attributes"] = attributes;
    return result;
  }

  // Musicアイテム（再生時）変換
  static Map<String,dynamic> likeMusicToItem(LikeMusic likeMusic){
    Map<String,dynamic> result = {};
    result["id"] = likeMusic.musicId;
    result["type"] = "songs";
    Map<String,dynamic> playParams = {};
    playParams["id"] = likeMusic.musicId;
    playParams["kind"] = "song";
    Map<String,dynamic> attributes = {};
    attributes["playParams"] = playParams;
    result["attributes"] = attributes;
    return result;
  }

  // Musicアイテム（再生時）変換
  MusicItem copyWith(){
    return MusicItem(id, type, attributes, durationInSec, artworkUrl, musicUrl, musicName, artistName);
  }
}
