import 'dart:convert';

import '../models/auth_session.dart';

class JwtDecoderService {
  const JwtDecoderService();

  AuthSession decodeSession(String token) {
    final payload = _decodePayload(token);
    final username = payload['sub'];
    final userId = payload['userId'];
    final companyId = payload['companyId'];
    final role = payload['role'];
    final exp = payload['exp'];

    if (username is! String ||
        userId is! String ||
        companyId is! String ||
        role is! String ||
        exp is! int) {
      throw const FormatException('JWT is missing required mobile claims.');
    }

    return AuthSession(
      token: token,
      username: username,
      userId: userId,
      companyId: companyId,
      role: role,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(exp * 1000),
    );
  }

  Map<String, Object?> _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid JWT format.');
    }

    final normalized = base64Url.normalize(parts[1]);
    final payload = utf8.decode(base64Url.decode(normalized));
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Invalid JWT payload.');
    }
    return decoded;
  }
}
