import 'package:music_prototype/model/like_music/like_music.dart';
import 'package:music_prototype/model/music/Genre.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LikeMusicRepository {

  static Database? database;
  static const String tableName = 'like_music';

  static Future<void> createTable(Database db, int version) async {
    await db.execute(
        'create table $tableName(id integer PRIMARY KEY AUTOINCREMENT, music_id TEXT, music_name TEXT, artist_name TEXT, genre TEXT, genre_name TEXT, artwork_url TEXT, created_at TEXT)');
  }

  // static Future<Database> initDb() async {
  //   String path = join(await getDatabasesPath(), 'target_history_app.db');
  //   return await openDatabase(path, version: 1, onCreate: _createTable);
  // }
  //
  // static Future<Database?> setDb() async {
  //   if (database == null) {
  //     database = await initDb();
  //     return database;
  //   } else {
  //     return database;
  //   }
  // }

  static Future<int> insertLikeMusic(LikeMusic likeMusic) async {
    await database!.insert(tableName, {
      'music_id': likeMusic.musicId,
      'music_name': likeMusic.musicName,
      'artist_name': likeMusic.artistName,
      'genre': likeMusic.genre,
      'genre_name': likeMusic.genreName,
      'artwork_url': likeMusic.artworkUrl,
      'created_at': DateTime.now().toString()
    });
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    return maps.last['id'];
  }

  static Future<List<LikeMusic>?> getLikeMusicList() async {
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    if (maps.isEmpty) {
      return null;
    } else {
      List<LikeMusic> likeMusicList = List.generate(
          maps.length,
              (index) => LikeMusic(
            musicId: maps[index]['music_id'],
            musicName: maps[index]['music_name'],
            artistName: maps[index]['artist_name'],
            genre: maps[index]['genre'],
            genreName: maps[index]['genre_name'],
            artworkUrl: maps[index]['artwork_url'],
            createdAt: DateTime.parse(maps[index]['created_at']),
          ));
      return likeMusicList;
    }
  }
  static Future<List<LikeMusic>> getLikeMusicListByGenre(String genre) async {
    print("k" +genre);
    final List<Map<String, dynamic>> maps = await database!.query(tableName, where: 'genre = ?', whereArgs: [genre]);
    if (maps.isEmpty) {
      return [];
    } else {
      List<LikeMusic> likeMusicList = List.generate(
          maps.length,
              (index) => LikeMusic(
            musicId: maps[index]['music_id'],
            musicName: maps[index]['music_name'],
            artistName: maps[index]['artist_name'],
            genre: maps[index]['genre'],
            genreName: maps[index]['genre_name'],
            artworkUrl: maps[index]['artwork_url'],
            createdAt: DateTime.parse(maps[index]['created_at']),
          ));
      return likeMusicList;
    }
  }

  static Future<List<Genre>> getLikeMusicGenreList() async {
    final List<Map<String, dynamic>> maps = await database!.query(tableName, groupBy: "genre");
    if (maps.isEmpty) {
      return [];
    } else {
      List<Genre> likeGenre = List.generate(
        maps.length,
            (index) =>
            Genre(
                maps[index]['genre'],
                {"name": maps[index]["genre_name"]}),
      ).toList();
      return likeGenre;
    }
  }

  // static Future<int> updateTargetHistory(TargetHistory targetHistory) async {
  //   final result = await database!.update(
  //       tableName,
  //       {
  //         'target_content': targetHistory.targetContent
  //       },
  //       where: 'id = ?',
  //       whereArgs: [target.targetId]);
  //   return result;
  // }

  static Future<int> deleteLikeMusic(String musicId) async {
    final result = await database!.delete(
        tableName,
        where: 'music_id = ?',
        whereArgs: [musicId]);
    return result;
  }
}