import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class LocalStorage {
  static const String key = "tasks";

  static Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data != null) {
      List decoded = jsonDecode(data);
      return decoded.map((e) => TaskModel.fromMap(e)).toList();
    }
    return [];
  }

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List mapped = tasks.map((e) => e.toMap()).toList();
    prefs.setString(key, jsonEncode(mapped));
  }
}
