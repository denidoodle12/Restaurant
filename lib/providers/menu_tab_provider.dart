import 'package:flutter/foundation.dart';

class MenuTabProvider extends ChangeNotifier {
  bool _showFoods = true;
  bool get showFoods => _showFoods;

  void selectFoods() {
    if (!_showFoods) {
      _showFoods = true;
      notifyListeners();
    }
  }

  void selectDrinks() {
    if (_showFoods) {
      _showFoods = false;
      notifyListeners();
    }
  }
}
