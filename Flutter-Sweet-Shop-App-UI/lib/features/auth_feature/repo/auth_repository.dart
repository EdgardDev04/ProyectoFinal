import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/user.dart';
import '../../../data/user_dao.dart';
import '../../../data/password_utils.dart';

class AuthRepository {
  final UserDao userDao;

  AuthRepository(this.userDao);

  static const _sessionKey = 'current_user_id';

  Future<User?> register(String name, String email, String password) async {
    final exists = await userDao.getUserByEmail(email);
    if (exists != null) return null;

    final salt = generateSalt();
    final hash = hashPassword(password, salt);

    final user = User(
      name: name,
      email: email,
      passwordHash: hash,
      salt: salt,
      createdAt: DateTime.now().toIso8601String(),
    );

    final id = await userDao.insertUser(user);
     return user.copyWith(id: id);
  }

  Future<User?> login(String email, String password) async {
    final user = await userDao.getUserByEmail(email);
    if (user == null) return null;

    final hash = hashPassword(password, user.salt);
    if (hash != user.passwordHash) return null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, user.id!);

    return user;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_sessionKey);
    if (id == null) return null;
    return userDao.getUserById(id);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
