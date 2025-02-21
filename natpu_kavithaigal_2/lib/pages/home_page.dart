import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:natpu_kavithaigal/pages/blog_container_page.dart';
import 'package:natpu_kavithaigal/pages/favorites_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../cards/poem_card.dart';
import '../utils/secrets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> _data;
  final List<String> _poems = [];
  late Future<void> _future;
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse(HOME_PAGE_API));
      _data = jsonDecode(response.body);

      if (_data['status'] == "success") {
        for (int i = 0; i < (_data['data'] as List<dynamic>).length; i++) {
          final String quote = _data['data'][i]["post_content"] as String;
          _poems.add(quote);
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
          "நட்பு கவிதைகள்",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/splash_screen.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Carousel with Clickable Dots
          FutureBuilder(
            future: _future,
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

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      autoPlay: false,
                      height: MediaQuery.of(context).size.height * 0.55,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: List.generate(
                      _poems.length,
                      (index) => PoemCard(poem: _poems[index]),
                    ),
                  ),

                  SizedBox(height: 16),
                  // Clickable Dots
                  GestureDetector(
                    onTap: () {},
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: 5,
                      effect: WormEffect(
                        dotHeight: 15,
                        dotWidth: 15,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey,
                      ),
                      onDotClicked: (index) {
                        _controller.animateToPage(index);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),

      bottomSheet: SizedBox(
        width: double.infinity,
        child: Container(
          height: 120,
          decoration: BoxDecoration(shape: BoxShape.rectangle),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BlogContainerPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Image.asset("assets/images/blog_icon.png"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FavoritesPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Image.asset("assets/images/favorites_icon.png"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.nextPage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Image.asset("assets/images/next_icon.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        ],
      ),
    );
  }
}
