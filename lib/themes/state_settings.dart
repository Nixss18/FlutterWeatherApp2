import 'package:flutter/widgets.dart';
import 'package:weather_app/themes/prefs.dart';

class StateSettings with ChangeNotifier {
  bool isEnabled = Prefs.instance?.getBool("darkModeEnabled") ?? false;
  Locale? langChange;

  void toggleDarkMode() {
    isEnabled = !isEnabled;
    Prefs.instance?.setBool("darkModeEnabled", isEnabled);
    notifyListeners();
  }

  void languageChanged(String? lang) {
    Prefs.instance?.setString("Language", lang!);
    langChange = Locale(Prefs.instance?.getString("Language") ?? "lv");
    notifyListeners();
  }
}
