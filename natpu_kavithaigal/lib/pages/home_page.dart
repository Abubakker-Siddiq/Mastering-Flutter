import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:natpu_kavithaigal/pages/bookmarks_page.dart';

import '../utils/secrets.dart';
import 'favorites_page.dart';
import 'home_quotes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String clickedPopMenuItem;
  late Map<String, dynamic> data;
  List<String> quotes = [];
  int _currentBottomNavigationBarIndex = 0;
  late Future<void> future;


  @override
  void initState() {
    super.initState();
    future = getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse(HOME_PAGE_API));
      data = jsonDecode(response.body);

      if (data['status'] == "success") {
        for (int i = 0; i < (data['data'] as List<dynamic>).length; i++) {
          final String quote = data['data'][i]["post_content"] as String;
          quotes.add(quote);
        }
      } else {
        throw "Connect to the internet";
      }
    } catch (e) {
      throw "Connect to the internet";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Natpu Kavithaigal",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),

      // Quotes
      body: FutureBuilder(
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: IndexedStack(
              index: _currentBottomNavigationBarIndex,
              children: [
                HomeQuotesPage(quotes: quotes),
                const BookmarksPage(),
                const FavouritesPage(),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        currentIndex: _currentBottomNavigationBarIndex,
        onTap: (value) {
          setState(() {
            _currentBottomNavigationBarIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 35),
            activeIcon: Icon(Icons.home, size: 35),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border, size: 35),
            activeIcon: Icon(Icons.bookmark, size: 35),
            label: "Saved",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 35),
            activeIcon: Icon(Icons.favorite, size: 35),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
