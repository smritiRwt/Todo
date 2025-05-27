import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  HomeProvider() {
    loadTasks(); // Automatically load when provider is initialized
  }

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getStringList('tasks') ?? [];

    tasks =
        storedTasks.map((taskStr) {
          return jsonDecode(taskStr) as Map<String, dynamic>;
        }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getStringList('tasks') ?? [];

    if (index < storedTasks.length) {
      storedTasks.removeAt(index);
      await prefs.setStringList('tasks', storedTasks);
      await loadTasks(); // Refresh the list
    }
  }

  Future<void> updateTask(int index, Map<String, dynamic> updatedTask) async {
    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getStringList('tasks') ?? [];

    if (index < storedTasks.length) {
      storedTasks[index] = jsonEncode(updatedTask);
      await prefs.setStringList('tasks', storedTasks);
      await loadTasks(); // Refresh the list
    }
  }

  Future<void> toggleTaskCompletion(int index) async {
    if (index < tasks.length) {
      final task = Map<String, dynamic>.from(tasks[index]);
      task['isCompleted'] = !(task['isCompleted'] ?? false);
      await updateTask(index, task);
    }
  }
}
