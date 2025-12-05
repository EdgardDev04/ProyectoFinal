import 'package:sqflite/sqflite.dart';

import '../../../core/data/db.dart';

class SettingsDao {
  final table = 'settings';

  Future<void> setValue(String key, String value) async {
    final db = await AppDatabase.instance.database;
    await db.insert(table, {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getValue(String key) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(table, where: 'key = ?', whereArgs: [key]);
    if (res.isEmpty) return null;
    return res.first['value'] as String?;
  }
}
