import 'package:flutter/material.dart';
import 'package:natpu_kavithaigal/cards/blog_card.dart';
import 'package:natpu_kavithaigal/cards/quote_card.dart';

class BlogQuotesPage extends StatefulWidget {
  final int blogIndex;
  final List<String> quotes;

  const BlogQuotesPage({
    super.key,
    required this.blogIndex,
    required this.quotes,
  });

  @override
  State<BlogQuotesPage> createState() => _BlogQuotesPageState();
}

class _BlogQuotesPageState extends State<BlogQuotesPage> {
  @override
  Widget build(BuildContext context) {
    final int blogIndex = widget.blogIndex;
    final List<String> quotes = widget.quotes;
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              QuoteCard(
                originalQuote: quote,
                quote: "${(blogIndex * 50) + index + 1}. $quote",
                wantToRemoveFromBookmarks: false,
                wantToRemoveFromFavorites: false,
              ),

              index == 49 && blogIndex != 39
                  ? BlogCard(index: blogIndex + 1, quotes: [],)
                  : SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
