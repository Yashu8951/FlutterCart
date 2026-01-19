import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Model {
  static Database? _db;

  Future<Database> _openDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'user.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'token TEXT'
              ')',
        );
      },
    );
  }

  Future<void> addToken(String token) async {
    try {
    _db ??= await _openDB();
    await _db!.insert('users', {'token': token});
  }catch(e) {
      print(e.toString());
      throw e.toString();
    }
  }


  Future<void> deleteToken(String token) async
  {
    _db = await _openDB();
    await _db!.delete("users",where: 'token=?' ,whereArgs: [token]);
  }
}
