// lib/Core/RouteManager.dart

import 'package:flutter/material.dart';
import '../screens/about_screen.dart';
import '../screens/post_detail.dart';
import '../screens/settings_screen.dart'; // Importe a nova tela
import '../screens/timeline_screen.dart';

// O enum agora inclui a nova tela de configurações
enum AppRoute {
  timeline,
  postDetail,
  about,
  settings // <-- Rota nova
}

// A classe RouteManager (widget) não é mais necessária.
// Apenas a classe AppRoutes que define os caminhos.
class AppRoutes {
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.timeline: '/timeline',
    AppRoute.postDetail: '/postDetail',
    AppRoute.about: '/about',
    AppRoute.settings: '/settings', // <-- Rota nova
  };

  static String getRoute(AppRoute route) => _routeNames[route]!;

  static final Map<String, WidgetBuilder> routes = {
    getRoute(AppRoute.timeline): (context) => const TimelineScreen(),
    getRoute(AppRoute.postDetail): (context) => const PostDetailScreen(),
    getRoute(AppRoute.about): (context) => const AboutScreen(),
    getRoute(AppRoute.settings): (context) => const SettingsScreen(), // <-- Rota nova
  };
}