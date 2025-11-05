// lib/utils/translations.dart
class AppLocalizations {
  static const supportedLanguages = ['vi', 'en'];

  static const Map<String, Map<String, String>> localizedStrings = {
    'vi': {
      'today': 'Hôm nay',
      'next5days': 'Thời tiết 5 ngày tới',
      'feelsLike': 'Cảm giác như',
      'day': 'Ban ngày',
      'night': 'Ban đêm',
      'error': 'Lỗi tải dữ liệu',
      "no_data": "Không có dữ liệu",
      'city_hanoi': 'Hà Nội',
      'city_newyork': 'New York',
      'city_tokyo': 'Tokyo',
      'city_london': 'London',
      'lang_vi': 'Tiếng Việt',
      'lang_en': 'English',
    },
    'en': {
      'today': 'Today',
      'next5days': 'Next 5 days forecast',
      'feelsLike': 'Feels like',
      'day': 'Daytime',
      'night': 'Nighttime',
      'error': 'Failed to load data',
      "no_data": "No data available",
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
