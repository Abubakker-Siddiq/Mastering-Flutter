import 'package:flutter/material.dart';

import '../../pages/blog_quotes_page.dart';

class BlogPage extends StatefulWidget {
  final List<String> quotes;
  final int blogIndex;

  const BlogPage({super.key, required this.blogIndex, required this.quotes});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> quotes = widget.quotes;
    final blogIndex = widget.blogIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog ${(blogIndex * 50) + 1} - ${(blogIndex * 50) + quotes.length}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: BlogQuotesPage(quotes: quotes, blogIndex: blogIndex),
    );
  }
}
