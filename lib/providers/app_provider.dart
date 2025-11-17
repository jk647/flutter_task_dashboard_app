import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  int _counter = 0;
  String _note = '';

  int get counter => _counter;
  String get note => _note;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

  void setNote(String value) {
    _note = value;
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    _note = '';
    notifyListeners();
  }
}
