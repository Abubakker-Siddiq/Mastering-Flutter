import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natpu_kavithaigal/providers/bookmarks_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/favorites_provider.dart';

class QuoteDetailsPage extends StatefulWidget {
  final String quote;

  const QuoteDetailsPage({super.key, required this.quote});

  @override
  State<QuoteDetailsPage> createState() => _QuoteDetailsPageState();
}

class _QuoteDetailsPageState extends State<QuoteDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final quote = widget.quote;
    return Scaffold(
      appBar: AppBar(title: Text("Poem"), centerTitle: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(quote, style: TextStyle(fontSize: 20)),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.copy, size: 30),
              onPressed: () {
                setState(() {
                  copyToClipboard(context, quote);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.share, size: 30),
              onPressed: () {
                shareQuote(quote);
              },
            ),
            IconButton(
              icon: Icon(
                !isQuoteInBookmarks(quote)
                    ? Icons.bookmark_border
                    : Icons.bookmark,
                size: 30,
              ),
              onPressed: () {
                addQuoteToBookmarks(quote);
              },
            ),
            IconButton(
              icon: Icon(
                !isQuoteInFavorites(quote)
                    ? Icons.favorite_border
                    : Icons.favorite,
                size: 30,
              ),
              onPressed: () {
                addQuoteToFavorites(quote);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isQuoteInBookmarks(String quote) {
    return Provider.of<BookmarksProvider>(context).isQuoteInBookmarks(quote);
  }

  bool isQuoteInFavorites(String quote) {
    return Provider.of<FavoritesProvider>(context).isQuoteInFavorites(quote);
  }

  // Function to share quotes
  void shareQuote(String quote) {
    Share.share(quote);
  }

  // Function to copy quote in clipboard
  void copyToClipboard(BuildContext context, String quote) async {
    await Clipboard.setData(ClipboardData(text: quote));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Text copied to clipboard!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // Function to add quote in favorites
  Future<void> addQuoteToFavorites(String quote) async {
    bool hasQuoteAdded = await Provider.of<FavoritesProvider>(
      context,
      listen: false,
    ).addToFavorites(quote);

    if (hasQuoteAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Quote added to Favorites",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Quote already exists in favorites",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> addQuoteToBookmarks(String quote) async {
    bool hasQuoteAddedToBookmarks = await Provider.of<BookmarksProvider>(
      context,
      listen: false,
    ).addToBookmarks(quote);

    if (hasQuoteAddedToBookmarks) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Quote added to bookmarks",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Quote already exists in bookmarks",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
