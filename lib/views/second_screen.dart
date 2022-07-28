import 'package:flutter/material.dart';
import 'package:weather_app/api/api.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/themes/prefs.dart';
import 'package:weather_app/views/weekly_weather.dart';
import 'package:weather_app/api/weather.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late Future<WeeklyWeather>? futureWeeklyWeather;
  double? lat, lon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lat = Prefs.instance?.getDouble('lat');
    lon = Prefs.instance?.getDouble('lon');
    _getWeather(lat!, lon!);
  }

  void _getWeather(double latitude, double longitude) {
    futureWeeklyWeather = Api.client.getHttpWeekly(latitude, longitude);
  }

  String convertToDateTime(int? timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    String dateTime = date.year.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.day.toString();
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date;
    var timestamp;

    return Scaffold(
        appBar: AppBar(title: Text("Weekly View")),
        body: Center(
          child: FutureBuilder<WeeklyWeather>(
            future: futureWeeklyWeather,
            builder: (context, snapshot) {
              WeeklyWeather? weeklyWeather = snapshot.data;
              // print(weeklyWeather?.daily?.first.temp?.day);
              if (snapshot.hasData) {
                // return Text(
                //     "${weeklyWeather?.daily?.first.weather?.first.description}");
                return ListView.builder(
                  itemCount: snapshot.data?.daily?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(children: [
                        ListTile(
                          leading: Text(convertToDateTime(
                              snapshot.data?.daily?[index].dt)),
                          title: Text(
                              "${snapshot.data?.daily?[index].temp?.day} C"),
                          trailing: Image.network(
                              'http://openweathermap.org/img/wn/${snapshot.data?.daily?[index].weather?.first.icon}@2x.png'),
                          subtitle: Text(
                              "${snapshot.data?.daily?[index].weather?.first.description}"),
                        ),
                      ]),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
              //return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
