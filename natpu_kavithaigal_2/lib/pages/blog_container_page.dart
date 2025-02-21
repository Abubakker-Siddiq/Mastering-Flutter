import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../cards/blog_card.dart';
import '../utils/secrets.dart';

class BlogContainerPage extends StatefulWidget {
  const BlogContainerPage({super.key});

  @override
  State<BlogContainerPage> createState() => _BlogContainerPageState();
}

class _BlogContainerPageState extends State<BlogContainerPage> {
  late Map<String, dynamic> data;
  List<String> poems = [];
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
          poems.add(quote);
        }
        blogLength = (poems.length / 50).ceil();
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

        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Color(0xFF303030),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < blogLength; i += 3)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                              blogLength - i >= 3
                                  ? [
                                    BlogCard(
                                      index: i,
                                      poems: poems.sublist(
                                        (i * 50),
                                        (i * 50) + 50,
                                      ),
                                    ),
                                    BlogCard(
                                      index: i + 1,
                                      poems: poems.sublist(
                                        ((i + 1) * 50),
                                        ((i + 1) * 50) + 50,
                                      ),
                                    ),
                                    BlogCard(
                                      index: i + 2,
                                      poems:
                                          poems.length - ((i + 2) * 50) >= 50
                                              ? poems.sublist(
                                                (i + 2) * 50,
                                                ((i + 2) * 50) + 50,
                                              )
                                              : poems.sublist(
                                                (i + 2) * 50,
                                                poems.length,
                                              ),
                                    ),
                                  ]
                                  : blogLength - i == 2
                                  ? [
                                    BlogCard(
                                      index: i,
                                      poems: poems.sublist(
                                        (i * 50),
                                        (i * 50) + 50,
                                      ),
                                    ),
                                    BlogCard(
                                      index: i + 1,
                                      poems:
                                          poems.length - ((i + 1) * 50) >= 50
                                              ? poems.sublist(
                                                (i + 1) * 50,
                                                ((i + 1) * 50) + 50,
                                              )
                                              : poems.sublist(
                                                (i + 1) * 50,
                                                poems.length,
                                              ),
                                    ),
                                  ]
                                  : [
                                    BlogCard(
                                      index: i,
                                      poems:
                                          poems.length - (i * 50) >= 50
                                              ? poems.sublist(
                                                i * 50,
                                                (i * 50) + 50,
                                              )
                                              : poems.sublist(
                                                i * 50,
                                                poems.length,
                                              ),
                                    ),
                                  ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
