import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/localizations/loaclization.dart';
import 'package:weather_app/themes/prefs.dart';
import 'package:weather_app/themes/state_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkModeEnabled = false;
  String? dropdownValue = "lv";

  var items = [
    'lv',
    'en',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = Prefs.instance?.getString("Language") ?? "en";
  }

  void updateLanguageChoice(String? choice) {
    context.read<StateSettings>().languageChanged(choice);
  }

  @override
  Widget build(BuildContext context) {
    // print(AppLocalizations.of(context).locale);
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
                title: Text("Switch language"),
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
                        dropdownValue = newValue;
                      });
                      updateLanguageChoice(newValue);
                    }),
              ),
            )
          ],
        ));
  }
}
