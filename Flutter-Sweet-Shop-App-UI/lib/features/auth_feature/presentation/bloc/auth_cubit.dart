import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sweet_shop_app_ui/data/user.dart';
import '../../../../data/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/password_utils.dart';
import 'package:intl/intl.dart';

sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final UserDao _dao;

  AuthCubit(this._dao) : super(AuthInitial());

  Future<void> register(String name, String email, String password) async {
  try {
    emit(AuthLoading());
    final exists = await _dao.getUserByEmail(email);
    if (exists != null) {
      emit(AuthError('Email ha sido registrado'));
      return;
    }

    final salt = generateSalt();
    final hash = hashPassword(password, salt);
    final now = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());

    final user = User(
      name: name,
      email: email,
      passwordHash: hash,
      salt: salt,
      createdAt: now,
    );

    final id = await _dao.insertUser(user);
    final newUser = await _dao.getUserById(id);

    // 🔥 Guardar sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', id);

    emit(AuthAuthenticated(newUser!));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> updateUser(User updated) async {
  await _dao.updateUser(updated);
  emit(AuthAuthenticated(updated));
}


  Future<void> login(String email, String password) async {
  try {
    emit(AuthLoading());
    final user = await _dao.getUserByEmail(email);
    if (user == null) {
      emit(AuthError('Usuario no encontrado'));
      return;
    }

    final hash = hashPassword(password, user.salt);
    if (hash == user.passwordHash) {
    
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_user_id', user.id!);

      emit(AuthAuthenticated(user));
    } else {
      emit(AuthError('Credenciales Incorrectas'));
    }
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> loadSession() async {
  emit(AuthLoading());
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('current_user_id');

  if (userId == null) {
    emit(AuthUnauthenticated());
    return;
  }

  final user = await _dao.getUserById(userId);

  if (user == null) {
    emit(AuthUnauthenticated());
  } else {
    emit(AuthAuthenticated(user));
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user_id');
  emit(AuthUnauthenticated());
}

}
