import 'dart:convert';
import 'package:controle_processos/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferencesRepository {
  static String get _appPrefersUser => "app_prefs_user";

  late UserModel userLogado;

  Future<bool> setUserSharedPreferences(UserModel userModel) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_appPrefersUser, json.encode(userModel));
  }

  static Future<bool> isLogged() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_appPrefersUser) != null ? true : false;
  }

  static isLogged2() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_appPrefersUser) != null ? true : false;
  }

  Future<UserModel> getUserSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    if (preferences.getString(_appPrefersUser) != null) {
      userLogado = UserModel.fromJson(
        jsonDecode(preferences.getString(_appPrefersUser)!),
      );
    }
    return userLogado;
  }

  Future removeUserSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_appPrefersUser);
  }
}
