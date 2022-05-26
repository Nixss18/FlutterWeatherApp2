import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/themes/state_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Container(
        child: Material(
          child: ListTile(
            title: Text("Enable Dark mode"),
            // trailing: Switch(
            //   value: darkModeEnabled,
            //   onChanged: (_) {},
            //   activeTrackColor: Colors.lightGreen,
            //   activeColor: Colors.green,
            // ),
            trailing: Consumer<StateSettings>(
              builder: (context, value, child) {
                return Switch(
                    value: value.isEnabled,
                    onChanged: (newValue) => value.toggleDarkMode());
              },
            ),
          ),
        ),
      ),
    );
  }
}
