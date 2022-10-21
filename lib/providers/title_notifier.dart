import 'package:flutter/material.dart';
////////////////////////////////////////////////////////////////////////////////
class TitleNotifier extends ChangeNotifier {
  String _title = 'Учеба';

  String get title => _title;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}