import 'package:flutter/material.dart';

class AdditionalItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalItem(this.icon, this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Icon(icon, size: 32),
          SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
