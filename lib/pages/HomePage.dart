import 'package:flutter/material.dart';
import 'package:weather_app/components/CustomAppBar.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = "Hanoi";
  String language = 'vi';

  String getCityImage(String city) {
    switch (city.toLowerCase()) {
      case 'hanoi':
        return 'assets/images/hanoi.jpg';
      case 'new york':
        return 'assets/images/newyork.jpg';
      case 'tokyo':
        return 'assets/images/tokyo.jpg';
      case 'london':
        return 'assets/images/london.jpg';
      default:
        return 'assets/images/default_city.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toggleTheme: widget.toggleTheme,
        city: city,
        language: language,
        onCityChanged: (val) => setState(() => city = val),
        onLanguageChanged: (val) => setState(() => language = val),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Image.asset(getCityImage(city), fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
