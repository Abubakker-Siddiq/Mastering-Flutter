import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> quotes = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    quotes = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<bool> addToFavorites(String quote) async {
    if (quotes.contains(quote)) {
      return false;
    }

    quotes.add(quote);
    await _saveFavorites();
    notifyListeners();
    return true;
  }

  Future<void> removeFromFavorites(String quote) async {
    quotes.remove(quote);
    await _saveFavorites();
    notifyListeners();
  }

  bool isQuoteInFavorites(String quote) {
    return quotes.contains(quote);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', quotes);
  }
}
