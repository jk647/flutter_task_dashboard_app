import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/item_model.dart';

enum DataState { loading, loaded, error }

class DataProvider with ChangeNotifier {
  List<Item> _items = [];
  DataState _state = DataState.loading;
  String _errorMessage = '';

  List<Item> get items => _items;
  DataState get state => _state;
  String get errorMessage => _errorMessage;

  DataProvider() {
    loadData();
  }

  Future<void> loadData() async {
    try {
      _state = DataState.loading;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 800));

      final String response = await rootBundle.loadString('assets/data.json');
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      _items = data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
      _state = DataState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = DataState.error;
      _errorMessage = 'Failed to load data: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  bool updateItem(int id, Item updatedItem) {
    try {
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Item? getItemById(int id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}