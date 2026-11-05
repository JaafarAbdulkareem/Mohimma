import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_time/models/task_model.dart';

/// Saves the task list on the device so it survives closing the app.
class TaskStorage {
  static const _key = 'tasks_v1';

  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TaskModel>> load() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_key);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<TaskModel> tasks) async {
    final prefs = await _prefs;
    await prefs.setString(
      _key,
      jsonEncode(tasks.map((t) => t.toJson()).toList()),
    );
  }
}
