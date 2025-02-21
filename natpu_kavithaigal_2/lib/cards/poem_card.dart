import 'package:flutter/material.dart';

class PoemCard extends StatefulWidget {
  final String poem;

  const PoemCard({super.key, required this.poem});

  @override
  State<PoemCard> createState() => _PoemCardState();
}

class _PoemCardState extends State<PoemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF9AD9F1), width: 5),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(60, 93, 112, 0.6),
            Color.fromRGBO(103, 114, 120, 0.6),
            Color.fromRGBO(60, 93, 112, 0.6),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:
              widget.poem != "பிடித்தவை காலியாக உள்ளது"
                  ? Text(
                    widget.poem,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                  : Center(
                    child: Text(
                      widget.poem,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
        ),
      ),
    );
  }
}
