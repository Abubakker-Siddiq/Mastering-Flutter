import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  final String title;
  final double price;
  final String image;
  final Color containerColor;

  const Product({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(
            "\$$price",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Center(child: Image.asset(image, height: 175)),
        ],
      ),
    );
  }
}
