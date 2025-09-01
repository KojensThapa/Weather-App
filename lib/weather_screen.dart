import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secreat.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // double temp = 0;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "Unexpected error occurred";
      }
      return data;
      // data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('Refresh button pressed');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;

          final getCurrentWeatherData = data['list'][0];

          final currentTemp = getCurrentWeatherData['main']['temp'];
          final currentSky = getCurrentWeatherData['weather'][0]['main'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Icon(currentSky == "Clouds" || currentSky == "Rain" ? Icons.cloud : Icons.sunny, size: 64),
                              SizedBox(height: 16),
                              Text("$currentSky", style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // weather forecast cards
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // first card
                      HourlyForcastItem(
                        time: "1 PM",
                        icon: Icons.wb_sunny,
                        temperature: "25°F",
                      ),
                      // second card
                      HourlyForcastItem(
                        time: "2 PM",
                        icon: Icons.cloud,
                        temperature: "24°F",
                      ),
                      // third card
                      HourlyForcastItem(
                        time: "3 PM",
                        icon: Icons.grain,
                        temperature: "22°F",
                      ),
                      // fourth card
                      HourlyForcastItem(
                        time: "4 PM",
                        icon: Icons.ac_unit,
                        temperature: "20°F",
                      ),
                      // fifth card
                      HourlyForcastItem(
                        time: "5 PM",
                        icon: Icons.wb_cloudy,
                        temperature: "21°F",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "78%",
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "12 mph",
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "1013 hPa",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
