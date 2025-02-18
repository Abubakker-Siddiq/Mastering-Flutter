import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/favorites_provider.dart';
import '../utils/global_variables.dart';

class BlogQuotes extends StatefulWidget {
  final int blogIndex;

  const BlogQuotes({super.key, required this.blogIndex});

  @override
  State<BlogQuotes> createState() => _BlogQuotesState();
}

class _BlogQuotesState extends State<BlogQuotes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          final quote = quotes[(widget.blogIndex * 50) + index];
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
                        "${(widget.blogIndex * 50) + index + 1}. $quote",
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
                        !isQuoteInFavorites(quote)
                            ? Icons.favorite_border
                            : Icons.favorite,
                      ),
                      onPressed: () {
                        addQuoteToFavorites(quote);
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
  void addQuoteToFavorites(String quote) {
    bool hasQuoteAdded = Provider.of<FavoritesProvider>(
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
}
