import 'package:flutter/widgets.dart';
import 'package:weather_app/api/weather.dart';

class FavoriteCityProvider with ChangeNotifier {
  final List<FavoriteCity> _cities = [];

  List<FavoriteCity> get cities => _cities;

  void addFavoriteCity(FavoriteCity city) {
    _cities.add(city);
    notifyListeners();
  }

  void removeFavoriteCity(FavoriteCity city) {
    _cities.remove(city);
    notifyListeners();
  }
}

class FavoriteCity {
  double? lat;
  double? lon;
  String? name;

  FavoriteCity(this.lat, this.lon, this.name);
}
