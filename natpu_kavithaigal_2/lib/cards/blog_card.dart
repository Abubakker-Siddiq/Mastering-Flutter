import 'package:flutter/material.dart';
import 'package:natpu_kavithaigal/pages/blog_page.dart';

class BlogCard extends StatelessWidget {
  final int index;
  final List<String> poems;

  const BlogCard({super.key, required this.index, required this.poems});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlogPage(index: index, poems: poems),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/blog_page_icon.png"),
                Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "${(index * 50) + 1} - ${index * 50 + poems.length}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
