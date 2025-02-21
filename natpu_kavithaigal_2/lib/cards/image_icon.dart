import 'package:flutter/material.dart';

class CustomImageIcon extends StatelessWidget {
  final String imageUrl;

  const CustomImageIcon({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      child: Image.asset(imageUrl),
    );
  }
}
