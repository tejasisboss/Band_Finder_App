import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String sharedPreferenceFirstNameKey = "FIRSTNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //saving data
  static Future<void> saveUserEmailSharedPreference(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, email);
  }

  static Future<void> saveFirstNameSharedPreference(String fName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceFirstNameKey, fName);
  }

  //getting data
  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getFirstNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceFirstNameKey);
  }

}