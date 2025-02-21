import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natpu_kavithaigal/cards/poem_card.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../cards/image_icon.dart';
import '../providers/favorites_provider.dart';

class BlogPage extends StatefulWidget {
  final int index;
  final List<String> poems;

  const BlogPage({super.key, required this.poems, required this.index});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final CarouselSliderController _controller = CarouselSliderController();
  late int _poemIndex;
  late String _currentPoem;

  @override
  void initState() {
    super.initState();
    _poemIndex = 0;
    _currentPoem = widget.poems[0];
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final poems = widget.poems;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "தொகுதி ${index + 1} -  ${(index * 50) + _poemIndex + 1}/${(index * 50) + poems.length}",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
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
                Column(
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
                            _poemIndex = index;
                            _currentPoem = poems[index];
                          });
                        },
                      ),
                      items: List.generate(
                        poems.length,
                        (index) => PoemCard(poem: poems[index]),
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFF35505A),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _controller.previousPage();
                            },
                            child: CustomImageIcon(
                              imageUrl: "assets/images/blog_left.png",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              sharePoem(_currentPoem);
                            },
                            child: CustomImageIcon(
                              imageUrl: "assets/images/blog_share.png",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                !isPoemInFavorites(_currentPoem)
                                    ? addPoemToFavorites(_currentPoem)
                                    : removePoemFromFavorites(_currentPoem);
                              });
                            },
                            child: CustomImageIcon(
                              imageUrl:
                                  !isPoemInFavorites(_currentPoem)
                                      ? "assets/images/blog_favorites.png"
                                      : "assets/images/blog_favorites_filled.png",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              copyToClipboard(context, _currentPoem);
                            },
                            child: CustomImageIcon(
                              imageUrl: "assets/images/blog_copy.png",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.nextPage();
                              });
                            },
                            child: CustomImageIcon(
                              imageUrl: "assets/images/blog_right.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        ],
      ),
    );
  }

  // Function that checks whether the poem exists or not
  bool isPoemInFavorites(String poem) {
    return Provider.of<FavoritesProvider>(
      context,
      listen: false,
    ).isQuoteInFavorites(poem);
  }

  // Function to share quotes
  void sharePoem(String poem) {
    Share.share(poem);
  }

  // Function to copy quote in clipboard
  void copyToClipboard(BuildContext context, String poem) async {
    await Clipboard.setData(ClipboardData(text: poem));

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
  Future<void> addPoemToFavorites(String poem) async {
    await Provider.of<FavoritesProvider>(
      context,
      listen: false,
    ).addToFavorites(poem);
  }

  // Function to remove quote in favorites
  void removePoemFromFavorites(String poem) {
    Provider.of<FavoritesProvider>(
      context,
      listen: false,
    ).removeFromFavorites(poem);
  }
}
