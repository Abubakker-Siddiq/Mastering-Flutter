import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../pages/quote_details_page.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/favorites_provider.dart';

class QuoteCard extends StatefulWidget {
  final String originalQuote;
  final String quote;
  final bool wantToRemoveFromBookmarks;
  final bool wantToRemoveFromFavorites;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.wantToRemoveFromBookmarks,
    required this.wantToRemoveFromFavorites,
    required this.originalQuote,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  @override
  Widget build(BuildContext context) {
    final String originalQuote = widget.originalQuote;
    final String quote = widget.quote;
    final bool wantToRemoveFromBookmarks = widget.wantToRemoveFromBookmarks;
    final bool wantToRemoveFromFavorites = widget.wantToRemoveFromFavorites;

    return Container(
      height: 220,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuoteDetailsPage(quote: originalQuote),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                quote,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                wantToRemoveFromBookmarks
                    ? IconButton(
                      icon: Icon(
                        !isQuoteInBookmarks(quote)
                            ? Icons.bookmark_border
                            : Icons.bookmark,
                      ),
                      onPressed: () {
                        removeFromTheBookmarks(quote);
                      },
                    )
                    : wantToRemoveFromFavorites
                    ? IconButton(
                      icon: Icon(
                        isQuoteInFavorites(quote)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        removeQuoteFromFavorites(quote);
                      },
                    )
                    : Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            !isQuoteInBookmarks(quote)
                                ? Icons.bookmark_border
                                : Icons.bookmark,
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
                          ),
                          onPressed: () {
                            addQuoteToFavorites(quote);
                          },
                        ),
                      ],
                    ),
              ],
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

  void removeFromTheBookmarks(String quote) {
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
            "Are you sure you want to remove this quote from bookmarks?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<BookmarksProvider>(
                  context,
                  listen: false,
                ).removeFromBookmarks(quote);
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
