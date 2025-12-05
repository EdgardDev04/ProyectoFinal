import 'package:flutter_sweet_shop_app_ui/data/user.dart';
import '../core/data/db.dart';

class UserDao {
  final table = 'users';

  Future<int> insertUser(User user) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(table, user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(table, where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<User?> getUserById(int id) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<int> updateUser(User user) async {
  final db = await AppDatabase.instance.database;
  return await db.update(
    table,
    user.toMap(),
    where: 'id = ?',
    whereArgs: [user.id],
  );
}


}
