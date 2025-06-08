// 1. IMPORT ESSENCIAL QUE ESTAVA FALTANDO
import 'package:flutter/material.dart';

import '../screens/about_screen.dart';
import '../screens/favorites_screen.dart';
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
  favorites,
}

class AppRoutes {
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.timeline: '/timeline',
    AppRoute.postDetail: '/postDetail',
    AppRoute.about: '/about',
    AppRoute.settings: '/settings',
    AppRoute.search: '/search',
    AppRoute.favorites: '/favorites',
  };

  // 2. A FUNÇÃO 'getRoute' PRECISA ESTAR AQUI
  static String getRoute(AppRoute route) => _routeNames[route]!;

  static final Map<String, WidgetBuilder> routes = {
    getRoute(AppRoute.timeline): (context) => const TimelineScreen(),
    getRoute(AppRoute.postDetail): (context) => const PostDetailScreen(),
    getRoute(AppRoute.about): (context) => const AboutScreen(),
    getRoute(AppRoute.settings): (context) => const SettingsScreen(),
    getRoute(AppRoute.search): (context) => const SearchScreen(),
    getRoute(AppRoute.favorites): (context) => const FavoritesScreen(),
  };
}