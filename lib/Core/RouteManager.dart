// TODOS OS IMPORTS DEVEM ESTAR NO TOPO DO ARQUIVO
import 'package:flutter/material.dart';
import '../screens/favorites_screen.dart';
import '../screens/post_detail.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/timeline_screen.dart';

// UMA ÚNICA DECLARAÇÃO DO ENUM
enum AppRoute {
  timeline,
  postDetail,
  settings,
  search,
  favorites,
}

// UMA ÚNICA DECLARAÇÃO DA CLASSE
class AppRoutes {
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.timeline: '/',
    AppRoute.postDetail: '/postDetail',
    AppRoute.settings: '/settings',
    AppRoute.search: '/search',
    AppRoute.favorites: '/favorites',
  };

  static String getRoute(AppRoute route) => _routeNames[route]!;

  static final Map<String, WidgetBuilder> routes = {
    getRoute(AppRoute.timeline): (context) => const TimelineScreen(),
    getRoute(AppRoute.postDetail): (context) => const PostDetailScreen(),
    getRoute(AppRoute.settings): (context) => const SettingsScreen(),
    getRoute(AppRoute.search): (context) => const SearchScreen(),
    getRoute(AppRoute.favorites): (context) => const FavoritesScreen(),
  };
}
