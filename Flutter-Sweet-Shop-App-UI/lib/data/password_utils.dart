import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateSalt([int length = 16]) {
  final rnd = Random.secure();
  final values = List<int>.generate(length, (_) => rnd.nextInt(256));
  return base64UrlEncode(values);
}

String hashPassword(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
