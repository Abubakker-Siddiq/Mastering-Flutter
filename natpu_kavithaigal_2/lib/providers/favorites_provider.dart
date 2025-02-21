import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> poems = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    poems = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<bool> addToFavorites(String poem) async {
    if (poems.contains(poem)) {
      return false;
    }

    poems.add(poem);
    await _saveFavorites();
    notifyListeners();
    return true;
  }

  Future<void> removeFromFavorites(String poem) async {
    poems.remove(poem);
    await _saveFavorites();
    notifyListeners();
  }

  bool isQuoteInFavorites(String poem) {
    return poems.contains(poem);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', poems);
  }
}
