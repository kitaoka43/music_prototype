class MusicItem {
  String id;
  String types;
  Map<String, Map<String, String>> attributes;
  int durationInSec;
  String artworkUrl;
  String musicName;
  String artistName;

  MusicItem(this.id, this.types, this.attributes, this.durationInSec, this.artworkUrl, this.musicName, this.artistName);

  static MusicItem createMusicItem(Map<String, dynamic> data){
    String id = data["id"];
    String types = data["type"];
    // print(data["attributes"]["durationInMillis"] / 1000);
    int durationInSec = (data["attributes"]["durationInMillis"]).toInt();
    String artworkUrl = data["attributes"]["artwork"]["url"];
    if (artworkUrl.isNotEmpty){
      artworkUrl = artworkUrl.replaceFirst("{w}", "400").replaceFirst("{h}", "400");
    }
    String musicName = data["attributes"]["name"];
    String artistName = data["attributes"]["artistName"];
    Map<String, String> playParams = {"id" : data["attributes"]["playParams"]["id"], "kind":  data["attributes"]["playParams"]["kind"]};
    Map<String, Map<String, String>> attributes = {"playParams":playParams};
    MusicItem musicItem = MusicItem(id, types, attributes, durationInSec, artworkUrl, musicName, artistName);
    return musicItem;
  }
}
