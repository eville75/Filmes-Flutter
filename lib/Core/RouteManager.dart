// lib/Core/RouteManager.dart

// 1. IMPORT ESSENCIAL QUE ESTAVA FALTANDO
import 'package:flutter/material.dart';

// O resto do seu código de rotas...
import '../screens/about_screen.dart';
import '../screens/post_detail.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/timeline_screen.dart';

enum AppRoute {
  timeline,
  postDetail,
  about,
  settings,
  search,
}

class AppRoutes {
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.timeline: '/timeline',
    AppRoute.postDetail: '/postDetail',
    AppRoute.about: '/about',
    AppRoute.settings: '/settings',
    AppRoute.search: '/search',
  };

  static String getRoute(AppRoute route) => _routeNames[route]!;

  // 2. O 'WidgetBuilder' AGORA SERÁ ENCONTRADO GRAÇAS AO IMPORT ACIMA
  static final Map<String, WidgetBuilder> routes = {
    getRoute(AppRoute.timeline): (context) => const TimelineScreen(),
    getRoute(AppRoute.postDetail): (context) => const PostDetailScreen(),
    getRoute(AppRoute.about): (context) => const AboutScreen(),
    getRoute(AppRoute.settings): (context) => const SettingsScreen(),
    getRoute(AppRoute.search): (context) => const SearchScreen(),
  };
}