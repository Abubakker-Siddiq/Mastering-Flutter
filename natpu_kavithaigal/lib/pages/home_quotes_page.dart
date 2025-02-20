import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natpu_kavithaigal/pages/blog_container.dart';
import 'package:natpu_kavithaigal/pages/quote_details_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/bookmarks_provider.dart';
import '../providers/favorites_provider.dart';

class HomeQuotesPage extends StatefulWidget {
  final List<String> quotes;

  const HomeQuotesPage({super.key, required this.quotes});

  @override
  State<HomeQuotesPage> createState() => _HomeQuotesPageState();
}

class _HomeQuotesPageState extends State<HomeQuotesPage> {
  late int quoteIndex;

  @override
  void initState() {
    super.initState();
    quoteIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final quotes = widget.quotes;
    final quote = quotes[quoteIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Container(
        height: 220,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuoteDetailsPage(quote: quote),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
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
                  SizedBox(width: 10), // Space between text and button
                  IconButton(
                    icon: Icon(Icons.navigate_next, size: 30),
                    onPressed: () {
                      setState(() {
                        if (quoteIndex < 4) {
                          quoteIndex = quoteIndex + 1;
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
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

                  quoteIndex == 4
                      ? TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => BlogContainer(),
                            ),
                          );
                        },
                        child: Text(
                          "Read more...",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                      : SizedBox(height: 0),
                ],
              ),
            ],
          ),
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
