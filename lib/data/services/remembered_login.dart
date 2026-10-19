class RememberedLogin {
  const RememberedLogin({
    required this.username,
    required this.password,
    required this.lastLoginAt,
  });

  final String username;
  final String password;
  final DateTime lastLoginAt;
}
