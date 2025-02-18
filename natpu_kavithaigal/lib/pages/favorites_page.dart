import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/favorites_provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    final favouriteQuotes = Provider.of<FavoritesProvider>(context).quotes;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: favouriteQuotes.length,
        itemBuilder: (context, index) {
          final quote = favouriteQuotes[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // This ensures space between the text and button
                  children: [
                    Expanded(
                      child: Text(
                        quote,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        setState(() {
                          copyToClipboard(context, quote);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        shareQuote(quote);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isQuoteInFavorites(quote)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        removeQuoteFromFavorites(quote);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool isQuoteInFavorites(String quote) {
    return Provider.of<FavoritesProvider>(context).isQuoteInFavorites(quote);
  }

  // Function to share quotes
  void shareQuote(String quote) {
    Share.share(quote);
  }

  void copyToClipboard(BuildContext context, String quote) async {
    await Clipboard.setData(ClipboardData(text: quote));

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Text copied to clipboard!')));
    }
  }

  void removeQuoteFromFavorites(String quote) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Confirm Deletion",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            "Are you sure you want to remove this quote from your favorites?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<FavoritesProvider>(
                  context,
                  listen: false,
                ).removeFromFavorites(quote);
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
