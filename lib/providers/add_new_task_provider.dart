import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_to_do/providers/tasks_provider.dart';
import 'package:flutter_to_do/view/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewTaskProvider extends ChangeNotifier {
  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskDateController = TextEditingController();
  final taskTimeController = TextEditingController();

  bool isLoading = false;

  void initializeControllers(Map<String, dynamic>? task) {
    if (task != null) {
      taskTitleController.text = task['title'] ?? '';
      taskDescriptionController.text = task['description'] ?? '';
      taskDateController.text =
          task['date']?.split('T')[0] ?? task['date'] ?? '';
      taskTimeController.text = task['time'] ?? '';
    } else {
      clearFields();
    }
  }

  Future<void> addTask(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final newTask = {
      'title': taskTitleController.text.trim(),
      'description': taskDescriptionController.text.trim(),
      'date': taskDateController.text.trim(),
      'time': taskTimeController.text.trim(),
    };
    final prefs = await SharedPreferences.getInstance();
    final existingTasks = prefs.getStringList('tasks') ?? [];
    existingTasks.add(jsonEncode(newTask));
    await prefs.setStringList('tasks', existingTasks);

    // Update the tasks in provider
    final provider = Provider.of<HomeProvider>(context, listen: false);
    await provider
        .loadTasks(); // Assuming you have a loadTasks method in HomeProvider

    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    clearFields();
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> saveTask(
    BuildContext context, {
    Map<String, dynamic>? task,
    int? index,
  }) async {
    isLoading = true;
    notifyListeners();

    final newTask = {
      'title': taskTitleController.text.trim(),
      'description': taskDescriptionController.text.trim(),
      'date': taskDateController.text.trim(),
      'time': taskTimeController.text.trim(),
    };

    final provider = Provider.of<HomeProvider>(context, listen: false);
    if (task != null && index != null) {
      await provider.updateTask(index, newTask);
      Future.delayed(const Duration(seconds: 1), () {
        isLoading = false;
        clearFields();
      });
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      await addTask(context); // Navigates to Home
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void clearFields() {
    taskTitleController.clear();
    taskDescriptionController.clear();
    taskDateController.clear();
    taskTimeController.clear();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    taskDateController.dispose();
    taskTimeController.dispose();
    super.dispose();
  }
}
