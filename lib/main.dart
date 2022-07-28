import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/favorites/favorite_provide.dart';
import 'package:weather_app/localizations/loaclization.dart';
import 'package:weather_app/themes/prefs.dart';
import 'package:weather_app/search/search_city.dart';
import 'package:weather_app/views/daily_weather_page.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/themes/state_settings.dart';
import 'package:weather_app/api/weather.dart';
import 'package:weather_app/api/city.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  StateSettings stateSettings;

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FavoriteCityProvider()),
    ChangeNotifierProvider(create: (_) => StateSettings())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<StateSettings>().isEnabled;
    return Consumer<StateSettings>(builder: (context, value, child) {
      return MaterialApp(
        title: "Weather App",
        supportedLocales: const [Locale('lv', ''), Locale('en', '')],
        locale: value.langChange,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light),
        home: DailyWeatherPage(),
      );
    });
  }
}
