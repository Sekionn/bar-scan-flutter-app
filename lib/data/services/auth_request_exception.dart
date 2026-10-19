class AuthRequestException implements Exception {
  const AuthRequestException(this.statusCode, {this.message});

  final int statusCode;
  final String? message;
}
