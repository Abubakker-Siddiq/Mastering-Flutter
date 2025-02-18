import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> quotes = [];

  bool addToFavorites(String quote) {
    if (quotes.any((q) => q == quote)) {
      return false;
    }

    quotes.add(quote);
    notifyListeners();
    return true;
  }

  void removeFromFavorites(String quote) {
    quotes.remove(quote);
    notifyListeners();
  }

  bool isQuoteInFavorites(String quote) {
    return quotes.any((q) => q == quote);
  }
}
