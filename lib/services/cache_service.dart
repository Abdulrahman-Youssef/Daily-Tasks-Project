import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/models/serializable.dart';

class CacheService {
  // Obtain shared preferences.

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  T? getValue<T>(String key) {
    String? text = prefs.getString(key);
    if (text == null) return null;
    return json.decode(text) as T;
  }

  Future<void> saveValue<T>(String key, T value) async {
    String text = json.encode(value);
    await prefs.setString(key, text);

  }

  T? getObject<T extends Serializable>(String key, T obj) {
    String? text = prefs.getString(key);
    if (text == null) return null;
    return obj..deserialize(text);
  }

  Future<void> saveObject<T extends Serializable>(String key, T value) async {
    String text = value.serialize();
    await prefs.setString(key, text);
  }

  List<T>? getList<T extends Serializable>(
      String key, T Function() getInstance) {
    List<String>? textList = prefs.getStringList(key);
    log('fetched list => $textList');
    if (textList == null) return null;
    return textList.map((text) => getInstance()..deserialize(text)).toList();
  }

  Future<void> saveList<T extends Serializable>(
      String key, List<T> value) async {
    List<String> textList = value.map((e) => e.serialize()).toList();
    await prefs.setStringList(key, textList);
  }
}
