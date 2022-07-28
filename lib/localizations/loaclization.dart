import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      "weatherAppTitle": "Weather App",
      "cityName": "City name",
      "temperature": "Temperature",
      "feelsLike": "Feels like",
      "minTemp": "Min temp",
      "maxTemp": "Max temp"
    },
    'lv': {
      "weatherAppTitle": "Laikapstākļu aplikācija",
      "cityName": "Pilsēta",
      "temperature": "Temperatūra",
      "feelsLike": "Pēc sajūtas",
      "minTemp": "Minimālā temperatūra",
      "maxTemp": "Maksimālā temperatūra",
    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

  // String get title {
  //   return _localizedValues[locale.languageCode]!['weatherAppTitle']!;
  // }

  // String get cityName {
  //   return _localizedValues[locale.languageCode]!['cityName']!;
  // }

  // String get temperature {
  //   return _localizedValues[locale.languageCode]!['temperature']!;
  // }

  // String get feelsLike {
  //   return _localizedValues[locale.languageCode]!['feelsLike']!;
  // }

  // String get minTemp {
  //   return _localizedValues[locale.languageCode]!['minTemp']!;
  // }

  // String get maxTemp {
  //   return _localizedValues[locale.languageCode]!['maxTemp']!;
  // }

  String getTranslations(String name) {
    return _localizedValues[locale.languageCode]![name]!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.languages().contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
