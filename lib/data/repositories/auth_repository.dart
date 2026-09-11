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

  final AuthApiService authApiService;
  final JwtDecoderService jwtDecoderService;
  final SecureTokenStorage secureTokenStorage;

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final result = await authApiService.login(
      username: username,
      password: password,
    );
    await secureTokenStorage.saveToken(result.token);
    final session = jwtDecoderService.decodeSession(result.token);
    if (session.isExpired) {
      await secureTokenStorage.clear();
      throw const ExpiredSessionException();
    }
    return session;
  }

  Future<AuthSession?> restoreSession() async {
    final token = await secureTokenStorage.readToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    final session = jwtDecoderService.decodeSession(token);
    if (session.isExpired) {
      await secureTokenStorage.clear();
      return null;
    }
    return session;
  }

  Future<void> logout() {
    return secureTokenStorage.clear();
  }
}

class ExpiredSessionException implements Exception {
  const ExpiredSessionException();
}
