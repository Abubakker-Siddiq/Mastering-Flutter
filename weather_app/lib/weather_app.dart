import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/additional_item.dart';
import 'package:weather_app/secrets.dart';

import 'forecast_card.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => App();
}

class App extends State<WeatherApp> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      const String cityName = "Chennai";
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey",
        ),
      );
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw Exception();
      }
      return data;
    } catch (e) {
      throw "Something went wrong";
    }
  }

  IconData getIcon(String weather) {
    return weather == "Clouds" || weather == "Rain" ? Icons.cloud : Icons.sunny;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        // Title
        title: const Text(
          "WeatherApp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        // Refresh Button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                () => {
                  setState(() {
                    getCurrentWeather();
                  }),
                },
          ),
        ],
      ),

      // Body
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            final currentWeatherData = data["list"][0];
            final currentTemperature = currentWeatherData["main"]["temp"];
            final currentWeather = currentWeatherData["weather"][0]["main"];
            final currentHumidity = currentWeatherData["main"]["humidity"];
            final currentWindSpeed = currentWeatherData["wind"]["speed"];
            final currentPressure = currentWeatherData["main"]["pressure"];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Card
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemperature K",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(getIcon(currentWeather), size: 64),
                                const SizedBox(height: 16),
                                Text(
                                  "$currentWeather",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Weather Forecast
                  const SizedBox(height: 16),
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Cards
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 1; i <= 8; i++)
                  //         ForecastCard(
                  //           data["list"][i]["dt_txt"].toString().substring(
                  //             10,
                  //             16,
                  //           ),
                  //           getIcon(data["list"][i]["weather"][0]["main"]),
                  //           data["list"][i]["main"]["temp"].toString(),
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  // Cards
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, i) {
                        final time = DateTime.parse(data["list"][i]["dt_txt"]);
                        return ForecastCard(
                          DateFormat("Hm").format(time),
                          getIcon(data["list"][i]["weather"][0]["main"]),
                          data["list"][i]["main"]["temp"].toString(),
                        );
                      },
                    ),
                  ),

                  // Additional Information
                  const SizedBox(height: 16),
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Additional Information Data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalItem(
                        Icons.water_drop,
                        "Humidity",
                        "$currentHumidity",
                      ),
                      AdditionalItem(
                        Icons.air,
                        "Wind Speed",
                        "$currentWindSpeed",
                      ),
                      AdditionalItem(
                        Icons.beach_access,
                        "Pressure",
                        "$currentPressure",
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
