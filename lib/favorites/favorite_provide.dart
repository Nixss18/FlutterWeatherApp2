import 'package:flutter/widgets.dart';
import 'package:weather_app/api/weather.dart';
import 'package:weather_app/database/DBProvider.dart';

class FavoriteCityProvider with ChangeNotifier {
  final List<FavoriteCity> _cities = [];
  List<FavoriteCity> get cities => _cities;
  void addFavoriteCity(FavoriteCity city) {
    _cities.add(city);
    DBProvider.instance.insert(city);
    // dbprovider?.queryAllRows();
    notifyListeners();
  }

  void removeFavoriteCity(FavoriteCity city) {
    _cities.remove(city);
    DBProvider.instance.delete(city.name);
    notifyListeners();
  }
}

class FavoriteCity {
  double? lat;
  double? lon;
  String? name;

  FavoriteCity(this.lat, this.lon, this.name);

  FavoriteCity.fromMap(dynamic map) {
    lat = map['lat'];
    lon = map['lon'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return {'lat': lat, 'lon': lon, 'name': name};
  }
}
