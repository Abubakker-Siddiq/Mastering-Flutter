import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;

  const ForecastCard(this.time, this.icon, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SizedBox(
        width: 110,
        child: Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Icon(icon, size: 32),
              SizedBox(height: 8),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }
}
