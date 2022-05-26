import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/themes/prefs.dart';
import 'package:weather_app/themes/state_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkModeEnabled = false;
  String dropdownValue = "Item 1";

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text("Enable dark mode"),
                trailing: Consumer<StateSettings>(
                  builder: ((context, value, child) {
                    return Switch(
                        value: value.isEnabled,
                        onChanged: (newValue) => value.toggleDarkMode());
                  }),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Switch language to latvian"),
                // trailing: Switch(
                //   value: latvianLanguageEnabled,
                //   onChanged: (_) {},
                // ),
                trailing: DropdownButton(
                  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ),
            )
          ],
        ));
  }
}
