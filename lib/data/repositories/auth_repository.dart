import '../models/auth_session.dart';
import '../services/auth_api_service.dart';
import '../services/jwt_decoder_service.dart';
import '../services/secure_token_storage.dart';

class AuthRepository {
  const AuthRepository({
    required this.authApiService,
    required this.jwtDecoderService,
    required this.secureTokenStorage,
  });

  static const rememberedLoginValidity = Duration(days: 30);

  final AuthApiService authApiService;
  final JwtDecoderService jwtDecoderService;
  final SecureTokenStorage secureTokenStorage;

  Future<AuthSession> login({
    required String username,
    required String password,
    bool rememberLogin = true,
  }) async {
    final result = await authApiService.login(
      username: username,
      password: password,
    );
    final session = jwtDecoderService.decodeSession(result.token);
    if (session.isExpired) {
      await secureTokenStorage.clear();
      throw const ExpiredSessionException();
    }

    await secureTokenStorage.saveToken(result.token);
    if (rememberLogin) {
      await secureTokenStorage.saveRememberedLogin(
        username: username,
        password: password,
        loggedInAt: DateTime.now(),
      );
    }
    return session;
  }

  Future<AuthSession?> restoreSession() async {
    final rememberedLogin = await secureTokenStorage.readRememberedLogin();
    if (rememberedLogin == null ||
        DateTime.now().difference(rememberedLogin.lastLoginAt) >
            rememberedLoginValidity) {
      await secureTokenStorage.clear();
      return null;
    }

    try {
      return await login(
        username: rememberedLogin.username,
        password: rememberedLogin.password,
        rememberLogin: false,
      );
    } catch (_) {
      await secureTokenStorage.clear();
      return null;
    }
  }

  Future<void> logout() {
    return secureTokenStorage.clear();
  }
}

class ExpiredSessionException implements Exception {
  const ExpiredSessionException();
}
