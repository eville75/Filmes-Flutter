// Core/RouteManager.dart

import 'package:flutter/material.dart';
import '../screens/timeline_screen.dart';
import '../screens/post_detail.dart'; // IMPORTAÇÃO CORRETA

// 1. O ENUM DEVE TER O NOME CORRETO
enum AppRoute {
  timeline,
  postDetail 
}

class RouteManager extends StatelessWidget {
  const RouteManager({super.key});

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
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.getRoute(AppRoute.timeline),
      routes: AppRoutes.routes,
    );
  }
}

class AppRoutes {
  // 2. O MAPA QUE LIGA O ENUM À STRING DEVE ESTAR CORRETO
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.timeline: '/timeline',
    AppRoute.postDetail: '/postDetail', // A string deve ser exatamente esta
  };

  static String getRoute(AppRoute route) => _routeNames[route]!;

  // 3. O MAPA FINAL DE ROTAS DEVE CONTER A ROTA E A TELA CORRETA
  static final Map<String, WidgetBuilder> routes = {
    getRoute(AppRoute.timeline): (context) => const TimelineScreen(),
    getRoute(AppRoute.postDetail): (context) => const PostDetailScreen(), 
  };
}