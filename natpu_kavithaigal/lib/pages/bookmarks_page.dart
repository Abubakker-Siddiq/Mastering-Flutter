import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cards/quote_card.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    final savedQuotes = Provider.of<BookmarksProvider>(context).bookmarks;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: savedQuotes.length,
        itemBuilder: (context, index) {
          final quote = savedQuotes[index];
          return Column(
            children: [
              QuoteCard(
                originalQuote: quote,
                quote: quote,
                wantToRemoveFromBookmarks: true,
                wantToRemoveFromFavorites: false,
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
