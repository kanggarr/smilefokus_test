import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentPage = 0;

  get currentPage => _currentPage;

  set currentIndex(int index) {
    _currentPage = index;
    notifyListeners();
  }
}
