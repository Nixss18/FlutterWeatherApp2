import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/api/api.dart';
import 'package:weather_app/api/city.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/api/weather.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({Key? key}) : super(key: key);

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  Future<List<City>>? futureCityData;
  Timer? _timer;
  final textFieldValue = TextEditingController();
  // final prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textFieldValue,
          decoration: InputDecoration(hintText: 'Search'),
          autofocus: true,
          onChanged: (String value) {
            if (value.isEmpty) {
              return;
            }
            // print("userInput ${userInput}");
            _timer?.cancel(); //atcel pieprasijumu
            _timer = Timer(const Duration(seconds: 1), () {
              setState(() {
                futureCityData = Api.client
                    .getHttpCity(value); //pec sekundes izsauc pieprasijumu
              });
            });
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<City>>(
          future: futureCityData,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // return Text(snapshot.data?[index].name ?? "No search");
                  return ListTile(
                    title: Text(snapshot.data?[index].name ?? "No values"),
                    onTap: () {
                      // selectedLat = snapshot.data?[index].lat;
                      // selectedLng = snapshot.data?[index].lon;

                      double? lat = snapshot.data?[index].lat;
                      double? lon = snapshot.data?[index].lon;
                      String? cityName = snapshot.data?[index].name;

                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const HomePage()));
                      saveCoords(lat!, lon!);
                      Navigator.of(context).pop(
                          SelectedCity(lat: lat, lon: lon, cityName: cityName));
                    },
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  saveCoords(double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("lat", lat);
    prefs.setDouble("lon", lon);
  }
}

class SelectedCity {
  final double? lat;
  final double? lon;
  final String? cityName;

  const SelectedCity({this.lat, this.lon, this.cityName});
}
