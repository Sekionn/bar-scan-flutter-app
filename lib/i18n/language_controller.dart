import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_language.dart';

class LanguageController extends ChangeNotifier {
  LanguageController({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _languageKey = 'app_language';

  final FlutterSecureStorage _storage;
  AppLanguage _language = AppLanguage.da;

  AppLanguage get language => _language;

  Future<void> load() async {
    try {
      _language = AppLanguage.fromCode(await _storage.read(key: _languageKey));
    } catch (_) {
      _language = AppLanguage.da;
    }
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) {
      return;
    }
    _language = language;
    notifyListeners();
    try {
      await _storage.write(key: _languageKey, value: language.code);
    } catch (_) {
      // The selected language still applies for the current app session.
    }
  }

  Future<void> toggle() {
    return setLanguage(
      _language == AppLanguage.da ? AppLanguage.en : AppLanguage.da,
    );
  }
}
