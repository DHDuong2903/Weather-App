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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toggleTheme: widget.toggleTheme,
        city: city,
        language: language,
        onCityChanged: (val) => setState(() => city = val),
        onLanguageChanged: (val) => setState(() => language = val),
      ),
    );
  }
}
