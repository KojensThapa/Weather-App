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
          final currentPressure = getCurrentWeatherData['main']['pressure'];
          final currentWindSpeed = getCurrentWeatherData['wind']['speed'];
          final currentHumidity = getCurrentWeatherData['main']['humidity'];

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
                              Icon(() {
                                if (currentSky == "Clouds") return Icons.cloud;
                                if (currentSky == "Rain")return Icons.cloudy_snowing;
                                if (currentSky == "Clear") return Icons.sunny;
                                if (currentSky == "Snow") return Icons.ac_unit;
                                return Icons.help; // fallback if no match
                              }(), size: 64),
                              SizedBox(height: 16),
                              Text(
                                "$currentSky",
                                style: TextStyle(fontSize: 20),
                              ),
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
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // first card
                      for (int i = 1; i <= 5; i++)
                        HourlyForcastItem(
                          time: data['list'][i]['dt_txt'].toString().substring(
                            11,
                            16,
                          ),
                          icon: () {
                            String condition =
                                data['list'][i]['weather'][0]['main'];
                            if (condition == "Rain")
                              return Icons.cloudy_snowing;
                            if (condition == "Clouds") return Icons.wb_cloudy;
                            if (condition == "Clear") return Icons.sunny;
                            if (currentSky == "Snow") return Icons.ac_unit;
                            return Icons.help; // default fallback
                          }(),
                          temperature: "${data['list'][i]['main']['temp']} K",
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
                      value: "$currentHumidity%",
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "$currentWindSpeed mph",
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "$currentPressure hPa",
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
