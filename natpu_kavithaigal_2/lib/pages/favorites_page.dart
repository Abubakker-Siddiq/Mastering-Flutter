import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../cards/image_icon.dart';
import '../cards/poem_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final CarouselSliderController _controller = CarouselSliderController();
  late int _poemIndex;

  @override
  void initState() {
    super.initState();
    _poemIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> poems = Provider.of<FavoritesProvider>(context).poems;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "பிடித்தவை ${poems.isNotEmpty ? (_poemIndex + 1) : 0}/${poems.length}",
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
                    });
                  },
                ),
                items:
                    poems.isNotEmpty
                        ? List.generate(
                          poems.length,
                          (index) => PoemCard(poem: poems[index]),
                        )
                        : [PoemCard(poem: "பிடித்தவை காலியாக உள்ளது")],
              ),
              Spacer(flex: 1),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xFF35505A),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (poems.isNotEmpty) _controller.previousPage();
                      },
                      child: CustomImageIcon(
                        imageUrl: "assets/images/blog_left.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (poems.isNotEmpty) sharePoem(poems[_poemIndex]);
                      },
                      child: CustomImageIcon(
                        imageUrl: "assets/images/blog_share.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (poems.isNotEmpty) {
                          setState(() {
                            !isPoemInFavorites(poems[_poemIndex])
                                ? addPoemToFavorites(poems[_poemIndex])
                                : removePoemFromFavorites(
                                  poems[_poemIndex],
                                  poems,
                                );
                          });
                        }
                      },
                      child: CustomImageIcon(
                        imageUrl:
                            poems.isNotEmpty &&
                                    !isPoemInFavorites(poems[_poemIndex])
                                ? "assets/images/blog_favorites.png"
                                : "assets/images/blog_favorites_filled.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (poems.isNotEmpty) {
                          copyToClipboard(context, poems[_poemIndex]);
                        }
                      },
                      child: CustomImageIcon(
                        imageUrl: "assets/images/blog_copy.png",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (poems.isNotEmpty) _controller.nextPage();
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
  void removePoemFromFavorites(String poem, List<String> poems) {
    Provider.of<FavoritesProvider>(
      context,
      listen: false,
    ).removeFromFavorites(poem);
    if (_poemIndex == poems.length && poems.isNotEmpty) {
      setState(() {
        _poemIndex = _poemIndex - 1;
      });
    }
  }
}
