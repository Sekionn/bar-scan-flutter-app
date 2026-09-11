class AuthSession {
  const AuthSession({
    required this.token,
    required this.username,
    required this.userId,
    required this.companyId,
    required this.role,
    required this.expiresAt,
  });

  final String token;
  final String username;
  final String userId;
  final String companyId;
  final String role;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
