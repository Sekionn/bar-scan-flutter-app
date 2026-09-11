class LoginResult {
  const LoginResult({required this.token});

  final String token;

  factory LoginResult.fromJson(Map<String, Object?> json) {
    final token = json['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Login response did not include a token.');
    }
    return LoginResult(token: token);
  }
}
