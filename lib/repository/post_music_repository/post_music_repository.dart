import 'package:music_prototype/model/post_music/post_music.dart';
import 'package:music_prototype/repository/like_music_repository/like_music_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';


class PostMusicRepository {

  static Database? database;
  static const String tableName = 'post_music';

  static Future<void> _createTable(Database db, int version) async {
    await db.execute(
        'create table $tableName(id integer PRIMARY KEY AUTOINCREMENT, music_id TEXT, created_at TEXT)');
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'music_swipe_app.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await _createTable(db, version);
      await LikeMusicRepository.createTable(db, version);
    });
  }

  static Future<Database?> setDb() async {
    if (database == null) {
      database = await initDb();
      LikeMusicRepository.database = database;
      return database;
    } else {
      return database;
    }
  }

  static Future<int> insertPostMusic(PostMusic postMusic) async {
    await database!.insert(tableName, {
      'music_id': postMusic.musicId,
      'created_at': DateTime.now().toString()
    });
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    return maps.last['id'];
  }

  static Future<PostMusic?> getTarget() async {
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    if (maps.isEmpty) {
      return null;
    } else {
      List<PostMusic> targetList = List.generate(
          maps.length,
              (index) => PostMusic(
            musicId: maps[index]['music_id'],
            createdAt: DateTime.parse(maps[index]['created_at']),
          ));
      return targetList[0];
    }
  }

  static Future<int> updateTarget(PostMusic postMusic) async {
    final result = await database!.update(
        tableName,
        {
          'created_at': postMusic.createdAt
        },
        where: 'music_id = ?',
        whereArgs: [postMusic.musicId]);
    return result;
  }

  static Future<int> deleteDate(String musicId) async {
    final result = await database!.delete(
        tableName,
        where: 'music_id = ?',
        whereArgs: [musicId]);
    return result;
  }
}