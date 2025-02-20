import 'package:flutter/material.dart';

import '../pages/blog_page.dart';

class BlogCard extends StatefulWidget {
  final List<String> quotes;
  final int index;

  const BlogCard({super.key, required this.index, required this.quotes});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  Widget build(BuildContext context) {
    final List<String> quotes = widget.quotes;
    final int i = widget.index;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlogPage(blogIndex: i, quotes: quotes),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: 50,
        child: Card(
          elevation: 10,
          child: Center(child: Text("Blog ${(i * 50) + 1} - ${(i * 50) + quotes.length}")),
        ),
      ),
    );
  }
}
