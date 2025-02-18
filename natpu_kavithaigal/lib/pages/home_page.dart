import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/secrets.dart';
import 'blog_page.dart';
import 'favorites_page.dart';
import 'home_quotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String clickedPopMenuItem;
  late List<dynamic> data;
  int _currentBottomNavigationBarIndex = 0;
  late int _blogIndex;

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
          "Natpu Kavithaigal",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                _blogIndex = int.parse(value);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlogPage(blogIndex: _blogIndex);
                  },
                ),
              );
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(value: '0', child: Text("Block 1-50")),
                PopupMenuItem<String>(value: '1', child: Text("Block 51-100")),
                PopupMenuItem<String>(value: '2', child: Text("Block 101-150")),
                PopupMenuItem<String>(value: '3', child: Text("Block 151-200")),
              ];
            },
          ),
        ],
      ),

      // Quotes
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

          return IndexedStack(
            index: _currentBottomNavigationBarIndex,
            children: [HomeQuotes(), const FavouritesPage()],
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
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
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 35),
            activeIcon: Icon(Icons.favorite, size: 35),
            label: "",
          ),
        ],
      ),
    );
  }
}
