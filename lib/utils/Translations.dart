// lib/utils/translations.dart
class AppLocalizations {
  static const supportedLanguages = ['vi', 'en'];

  static const Map<String, Map<String, String>> localizedStrings = {
    'vi': {
      'city_hanoi': 'Hà Nội',
      'city_newyork': 'New York',
      'city_tokyo': 'Tokyo',
      'city_london': 'London',
      'lang_vi': 'Tiếng Việt',
      'lang_en': 'English',
    },
    'en': {
      'city_hanoi': 'Hanoi',
      'city_newyork': 'New York',
      'city_tokyo': 'Tokyo',
      'city_london': 'London',
      'lang_vi': 'Vietnamese',
      'lang_en': 'English',
    },
  };

  static String get(String key, String lang) {
    return localizedStrings[lang]?[key] ?? localizedStrings['en']![key]!;
  }
}
