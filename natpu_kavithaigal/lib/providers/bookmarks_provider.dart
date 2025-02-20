import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksProvider extends ChangeNotifier {
  List<String> bookmarks = [];

  BookmarksProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    bookmarks = prefs.getStringList('bookmarks') ?? [];
    notifyListeners();
  }

  Future<bool> addToBookmarks(String quote) async {
    if (bookmarks.contains(quote)) {
      return false;
    }

    bookmarks.add(quote);
    await _saveBookmarks();
    notifyListeners();
    return true;
  }

  Future<void> removeFromBookmarks(String quote) async {
    bookmarks.remove(quote);
    await _saveBookmarks();
    notifyListeners();
  }

  bool isQuoteInBookmarks(String quote) {
    return bookmarks.contains(quote);
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', bookmarks);
  }
}
