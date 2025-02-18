import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/secrets.dart';
import '../../pages/blog_quotes.dart';

class BlogPage extends StatefulWidget {
  final int blogIndex;

  const BlogPage({super.key, required this.blogIndex});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late List<dynamic> data;

  Future<void> getData() async {
    try {
      final url = Uri.parse('https://api.api-ninjas.com/v1/quotes');
      final response = await http.get(url, headers: {'X-Api-Key': APIKey});
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
      } else {
        throw ("Connect to the internet");
      }
    } catch (e) {
      throw ("Connect to the internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitleText(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
            );
          }

          return BlogQuotes(blogIndex: widget.blogIndex);
        },
      ),
    );
  }

  String getTitleText() {
    return "Blog ${(widget.blogIndex * 50) + 1} - ${(widget.blogIndex * 50) + 50}";
  }
}
