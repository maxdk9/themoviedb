import 'package:flutter/cupertino.dart';

class LocalizedModelStorage {
  String _localeTag = '';
  String get localeTag => _localeTag;

  LocalizedModelStorage() {}

  bool updateLocale(Locale locale) {
    final localeTag = locale.toLanguageTag();
    if (_localeTag == localeTag) return false;
    _localeTag = localeTag;
    return true;
  }
}
