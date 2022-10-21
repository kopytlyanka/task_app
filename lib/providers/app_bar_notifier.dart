import 'package:flutter/material.dart';
////////////////////////////////////////////////////////////////////////////////
class AppBarNotifier extends ChangeNotifier {
  bool _isUnchecked = false;
  bool _isOnlyFavorite = false;

  bool get isUnchecked => _isUnchecked;
  bool get isOnlyFavorite => _isOnlyFavorite;

  void toggleUnchecked() {
    _isUnchecked = !_isUnchecked;
    notifyListeners();
  }

  void toggleOnlyFavorite() {
    _isOnlyFavorite = !_isOnlyFavorite;
    notifyListeners();
  }
}