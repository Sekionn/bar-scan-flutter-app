enum AppLanguage {
  da('da'),
  en('en');

  const AppLanguage(this.code);

  final String code;

  static AppLanguage fromCode(String? code) {
    return switch (code) {
      'en' => AppLanguage.en,
      _ => AppLanguage.da,
    };
  }
}
