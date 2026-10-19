import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'remembered_login.dart';

class SecureTokenStorage {
  const SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'auth_username';
  static const _passwordKey = 'auth_password';
  static const _lastLoginAtKey = 'auth_last_login_at';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<void> saveRememberedLogin({
    required String username,
    required String password,
    required DateTime loggedInAt,
  }) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _passwordKey, value: password);
    await _storage.write(
      key: _lastLoginAtKey,
      value: loggedInAt.toUtc().toIso8601String(),
    );
  }

  Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<RememberedLogin?> readRememberedLogin() async {
    final username = await _storage.read(key: _usernameKey);
    final password = await _storage.read(key: _passwordKey);
    final lastLoginAtValue = await _storage.read(key: _lastLoginAtKey);
    final lastLoginAt = lastLoginAtValue == null
        ? null
        : DateTime.tryParse(lastLoginAtValue);

    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty ||
        lastLoginAt == null) {
      return null;
    }

    return RememberedLogin(
      username: username,
      password: password,
      lastLoginAt: lastLoginAt,
    );
  }

  Future<void> clear() {
    return Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _usernameKey),
      _storage.delete(key: _passwordKey),
      _storage.delete(key: _lastLoginAtKey),
    ]);
  }
}
