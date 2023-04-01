class Genre {
  String id;
  Map<String, String> attributes;

  Genre(this.id,this.attributes);

  // Musicアイテム生成
  static List<Genre> createGenreList(List<dynamic> dataList) {
    List<Genre> genreList = [];
    for (Map<String, dynamic> data in dataList) {
      String id = data["id"];
      Map<String, String> attributes = {"name": data["attributes"]["name"]};
      Genre genre = Genre(id, attributes);
      genreList.add(genre);
    }
    return genreList;
  }
}
