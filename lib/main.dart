// lib/main.dart

import 'package:flutter/material.dart';
import 'package:project/screens/timeline_screen.dart';
// A única importação importante é a do seu RouteManager
import 'Core/RouteManager.dart'; 

void main() {
  // A função main deve apenas chamar o runApp com o RouteManager
  runApp(const RouteManager());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmes Populares',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const TimelineScreen(),
    );
  }
}
