import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/api/api.dart';
import 'package:weather_app/api/city.dart';
import 'package:weather_app/favorites/favorite_provide.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/themes/prefs.dart';
import 'package:weather_app/search/search_city.dart';
import 'package:weather_app/views/second_screen.dart';
import 'package:weather_app/views/settings_view.dart';
import 'package:weather_app/api/weather.dart';
import '../localizations/loaclization.dart';
import '../search/search_city.dart';

class DailyWeatherPage extends StatefulWidget {
  const DailyWeatherPage({Key? key}) : super(key: key);

  @override
  State<DailyWeatherPage> createState() => _DailyWeatherPageState();
}

class _DailyWeatherPageState extends State<DailyWeatherPage>
    with SingleTickerProviderStateMixin {
  //tickerProviderp
  Future<CurrentWeather>? futureWeatherData;
  double? lat, lon;
  late Position position;
  bool gpsEnabled = false;
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  CurrentWeather? _weatherData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInitialData();
    lat = Prefs.instance?.getDouble('lat');
    lon = Prefs.instance?.getDouble('lon');

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchCity,
          ),
          // IconButton(
          //   icon: Icon(Icons.list),
          //   onPressed: _openWeeklyView,
          // ),
          IconButton(onPressed: _reloadPage, icon: Icon(Icons.replay)),
          Switch(
            value: gpsEnabled,
            onChanged: toggleLocation,
            activeTrackColor: Colors.lightGreen,
            activeColor: Colors.green,
          ),
        ],
      ),
      body: (lat != null && lon != null)
          ? Column(
              children: [
                Center(
                  child: FutureBuilder<CurrentWeather>(
                    future: futureWeatherData,
                    builder: (context, snapshot) {
                      print(snapshot.data?.iconList?.icons);
                      CurrentWeather? weather = snapshot.data;
                      if (snapshot.hasData) {
                        return weatherData(weather!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            )
          : Center(child: Text("SELECT DATA")),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text("Drawer header"),
            margin: EdgeInsets.zero,
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("favorites"),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                SelectedCity? coord = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SearchCity()));
                if (coord != null) {
                  context.read<FavoriteCityProvider>().addFavoriteCity(
                      FavoriteCity(coord.lat, coord.lon, coord.cityName));
                }
              },
            ),
          ),
          Divider(height: 0),
          Consumer<FavoriteCityProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (FavoriteCity city in provider.cities)
                    ListTile(
                      title: Text(city.name ?? "no value"),
                      trailing: IconButton(
                        icon: Icon(Icons.minimize_outlined),
                        onPressed: () {
                          provider.removeFavoriteCity(city);
                        },
                      ),
                    )
                ],
              );
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.open_in_browser),
            title: Text("Open weekly view"),
            onTap: _openWeeklyView,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: _openSettingView,
          ),
        ],
      )),
    );
  }

  Widget weatherData(CurrentWeather _currentWeather) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentWeather.iconList?.icons?.isNotEmpty ?? false)
            Image.network(
                'http://openweathermap.org/img/wn/${_currentWeather.iconList!.icons!.first.iconName}@2x.png'),
          Text(
            "${AppLocalizations.of(context)!.cityName}, ${_currentWeather.cityName}",
            style: const TextStyle(fontFamily: 'Schyler', fontSize: 24),
          ),
          Text(
            "${AppLocalizations.of(context)!.temperature}, ${_currentWeather.main?.temp}",
            style: const TextStyle(fontFamily: 'Schyler', fontSize: 24),
          ),
          Text(
            "${AppLocalizations.of(context)!.feelsLike}, ${_currentWeather.main?.feelsLike}",
            style: const TextStyle(fontFamily: 'Koulen', fontSize: 24),
          ),
          Text(
              "${AppLocalizations.of(context)!.minTemp}, ${_currentWeather.main?.tempMin}",
              style: const TextStyle(fontFamily: 'Koulen', fontSize: 20)),
          Text(
              "${AppLocalizations.of(context)!.minTemp} ${_currentWeather.main?.tempMax}",
              style: const TextStyle(fontFamily: 'Koulen', fontSize: 20)),
        ],
      ),
    );
  }

  void _openWeeklyView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SecondScreen()));
  }

  void _openSettingView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  void _searchCity() async {
    SelectedCity? coord = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SearchCity()));
    if (coord != null) {
      lat = coord.lat;
      lon = coord.lon;
      //sharedprefs
      setState(() {
        _getCurrentWeather(lat!, lon!);
      });
    }
  }

  Future<void> _reloadPage() async {
    if (gpsEnabled) {
      print(gpsEnabled);
      _getWeatherByPosition();
    } else {
      print(gpsEnabled);
      setState(() {
        _getCurrentWeather(lat!, lon!);
      });
    }
  }

  Future _getValuesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lat = prefs.getDouble("lat");
      lon = prefs.getDouble("lon");
      print("LAT FROM PREFS ${lat}");
    });
  }

  Future _getInitialData() async {
    await _getValuesFromPrefs();
    if (lat != null && lon != null) {
      // futureWeatherData = getHttp(lat, lon);
      _getCurrentWeather(lat!, lon!);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void toggleLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (!value) {
      prefs.setBool("gpsEnabled", value);
      setState(() {
        gpsEnabled = false;
      });
    } else {
      prefs.setBool("gpsEnabled", value);
      try {
        setState(() {
          gpsEnabled = true;
        });
        Position newPos = await _determinePosition();
        Prefs.instance?.setDouble("lat", newPos.latitude);
        Prefs.instance?.setDouble('lon', newPos.longitude);
        lat = newPos.latitude;
        lon = newPos.longitude;
        setState(() {
          _getCurrentWeather(newPos.latitude, newPos.longitude);
        });
      } catch (e) {
        setState(() {
          gpsEnabled = false;
        });
        print(e);
      }
    }
  }

  void _getCurrentWeather(double latitude, double longitude) {
    futureWeatherData = Api.client.getHttp(latitude, longitude);
  }

  void _getWeatherByPosition() async {
    try {
      Position newPos = await _determinePosition();
      Prefs.instance?.setDouble("lat", newPos.latitude);
      Prefs.instance?.setDouble('lon', newPos.longitude);
      lat = newPos.latitude;
      lon = newPos.longitude;
      setState(() {
        _getCurrentWeather(newPos.latitude, newPos.longitude);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error while loading data')));
    }
  }

  void _addCityToFavorites() async {
    await _getValuesFromPrefs();
    if (lat != null && lon != null) {
      ListTile(
        title: Text("${lat}"),
      );
    }
  }
}
