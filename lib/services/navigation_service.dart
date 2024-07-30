import 'package:flutter/material.dart';

class NavigationService extends ChangeNotifier {
  Widget _currentScreen;
  int _currentIndex;

  NavigationService({required Widget initialScreen, int initialIndex = 0})
      : _currentScreen = initialScreen,
        _currentIndex = initialIndex;

  Widget get currentScreen => _currentScreen;
  int get currentIndex => _currentIndex;

  void navigateTo(Widget screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
