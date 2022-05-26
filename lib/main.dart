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

// var options = BaseOptions(
//   baseUrl: "https://api.openweathermap.org",
//   connectTimeout: 5000,
//   receiveTimeout: 3000,
//   queryParameters: {
//     'appid': 'd339b378743357cd4befe21094335f5d',
//     'units': 'metric'
//   },
// );
// var cityOptions = BaseOptions(
//   baseUrl: "https://api.openweathermap.org",
//   connectTimeout: 5000,
//   receiveTimeout: 3000,
//   queryParameters: {
//     'limit': 5,
//     'appid': 'd339b378743357cd4befe21094335f5d',
//   },
// );
// Dio dioCity = Dio(cityOptions);
// Dio dio = Dio(options);

// Future<List<City>> getHttpCity() async {
//   var response = await Dio().get(
//       "https://api.openweathermap.org/geo/1.0/direct?q=Limbazi&limit=5&appid=493c32b6d579efb49f3d9ead947c9dbb");
//   List rawList = response.data as List;
//   return rawList.map((e) => City.fromJson(e)).toList();
// }

// Future<List<City>> getHttpCity() async {
//   final response =
//       await dioCity.get("/geo/1.0/direct", queryParameters: {'q': 'Limbazi'});
//   List rawList = response.data as List;
//   return rawList.map((e) => City.fromJson(e)).toList();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();

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
    return MaterialApp(
      title: "Weather App",
      locale: Locale('en', ''),
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('lv', ''), Locale('en', '')],
      theme: ThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light),
      home: DailyWeatherPage(),
    );
  }
}
