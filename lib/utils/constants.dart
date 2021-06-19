import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  //App related strings
  static String appName = "초행길";

  //Colors for theme
  static Color lightPrimary = Color(0xfff8fff7);
  static Color darkPrimary = Color(0xff2B2B2B);

  static Color lightAccent = Colors.black;
  static Color darkAccent = Color(0xff886EE4);

  static Color lightBG = Color(0xffffffff);
  static Color darkBG = Color(0xff2B2B2B);

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Roboto-Regular',
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
      color: lightBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto-Regular',
        ),
      ),
    ),
  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}

class ThemeNotifier extends ChangeNotifier {
  final String key = 'theme';
  SharedPreferences _prefs;
  bool _darkTheme;
  bool get dark => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadfromPrefs();
  }
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadfromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }
}
