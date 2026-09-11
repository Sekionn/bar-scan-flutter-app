import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../models/login_result.dart';

class AuthApiService {
  AuthApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('${AppConfig.backendBaseUrl}/auth/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 401) {
      throw const InvalidCredentialsException();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthRequestException(response.statusCode);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Invalid login response.');
    }
    return LoginResult.fromJson(decoded);
  }
}

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

class AuthRequestException implements Exception {
  const AuthRequestException(this.statusCode);

  final int statusCode;
}
