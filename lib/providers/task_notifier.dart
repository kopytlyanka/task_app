import 'package:flutter/material.dart';
import 'dart:collection';
import '../models/task.dart';
////////////////////////////////////////////////////////////////////////////////
class TaskNotifier extends ChangeNotifier {
  List<Task> _tasks = [
    Task(title: 'Flutter'),
    Task(title: 'Матан'),
    Task(title: 'ТРПО'),
    Task(title: 'веб'),
    Task(title: 'физра'),
  ];

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
  }

  void changeCheckAt(int idx) {
    _tasks[idx].isChecked = !_tasks[idx].isChecked;
    notifyListeners();
  }

  void changeFavAt(int idx) {
    _tasks[idx].isFav = !_tasks[idx].isFav;
    notifyListeners();
  }

  void removeTaskAt(int idx) {
    _tasks.removeAt(idx);
    notifyListeners();
  }

  void removeAllChecked() {
    _tasks = _tasks.where((task) => !task.isChecked).toList();
    notifyListeners();
  }
}