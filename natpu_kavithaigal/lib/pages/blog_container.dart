import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:natpu_kavithaigal/cards/blog_card.dart';

import '../utils/secrets.dart';

class BlogContainer extends StatefulWidget {
  const BlogContainer({super.key});

  @override
  State<BlogContainer> createState() => _BlogContainerState();
}

class _BlogContainerState extends State<BlogContainer> {
  late Map<String, dynamic> data;
  List<String> quotes = [];
  late int blogLength;
  late Future<void> future;


  @override
  void initState() {
    super.initState();
    future = getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse(ALL_POEMS_API));
      data = jsonDecode(response.body);

      if (data['status'] == "success") {
        for (int i = 0; i < (data['data'] as List<dynamic>).length; i++) {
          final String quote = data['data'][i]["post_content"] as String;
          quotes.add(quote);
        }
        blogLength =
            quotes.length ~/ 50 == 0
                ? quotes.length ~/ 50
                : quotes.length ~/ 50 + 1;
      } else {
        throw "Connect to the internet";
      }
    } catch (e) {
      throw "Connect to the internet";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
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

        return Scaffold(
          appBar: AppBar(
            title: Text("Blogs", style: Theme.of(context).textTheme.titleLarge),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < blogLength; i += 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          blogLength - i - 1 >= 2
                              ? [
                                BlogCard(
                                  index: i,
                                  quotes: quotes.sublist(
                                    (i * 50),
                                    (i * 50) + 50,
                                  ),
                                ),
                                BlogCard(
                                  index: i + 1,
                                  quotes: quotes.sublist(
                                    ((i + 1) * 50),
                                    quotes.length - ((i + 1) * 50) >= 50
                                        ? ((i + 1) * 50) + 50
                                        : ((i + 1) * 50) + quotes.length - ((i + 1) * 50),
                                  ),
                                ),
                              ]
                              : [
                                BlogCard(
                                  index: i,
                                  quotes: quotes.sublist(
                                    (i * 50),
                                    quotes.length - (i * 50) >= 50
                                        ? (i * 50) + 50
                                        : (i * 50) + quotes.length - (i * 50),
                                  ),
                                ),
                              ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
