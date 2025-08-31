import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
      body: Padding(
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
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '23°F',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.cloud, size: 64),
                          SizedBox(height: 16),
                          Text("Rainy", style: TextStyle(fontSize: 20)),
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
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // first card
                  HourlyForcastItem(),
                  // second card
                  HourlyForcastItem(),
                  // third card
                  HourlyForcastItem(),
                  // fourth card
                  HourlyForcastItem(),
                  // fifth card
                  HourlyForcastItem(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Additional weather info cards
            const Placeholder(fallbackHeight: 150),
          ],
        ),
      ),
    );
  }
}

class HourlyForcastItem extends StatelessWidget {
  const HourlyForcastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: const [
            Text(
              "11:00 AM",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Icon(Icons.wb_sunny, size: 32),
            SizedBox(height: 8),
            Text("270°F", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
