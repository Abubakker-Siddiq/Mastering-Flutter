import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  late double result;
  final TextEditingController textEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    result = 0;
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey,

      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Currency Converter",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "INR ${result == 0 ? 0 : result.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Please enter the amount in USD",
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.monetization_on),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: border,
                  focusedBorder: border,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: textEditingController,
              ),

              const SizedBox(height: 10),
              // Button
              ElevatedButton(
                onPressed: convert,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text("Convert"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void convert() {
    setState(() {
      result = textEditingController.text.trim() == "" ? 0 : (double.parse(textEditingController.text)) * 86.71;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();//
  }
}
