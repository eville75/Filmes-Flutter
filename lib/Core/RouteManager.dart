// ignore: file_names
import 'package:flutter/material.dart';
import '../screens/main_screen_shell.dart'; // A nova tela "casca"
import '../screens/post_detail.dart';


enum AppRoute {
  timeline, // Representa a rota inicial, que agora é a shell
  postDetail,
  // As rotas abaixo não são mais navegadas diretamente pela shell,
  // mas mantemos a definição para consistência.
  settings,
  search,
  favorites,
}

class AppRoutes {
  static const Map<AppRoute, String> _routeNames = {
    AppRoute.timeline: '/', // A rota inicial '/' aponta para a MainScreenShell
    AppRoute.postDetail: '/postDetail',
    AppRoute.settings: '/settings',
    AppRoute.search: '/search',
    AppRoute.favorites: '/favorites',
  };

  static String getRoute(AppRoute route) => _routeNames[route]!;

  static final Map<String, WidgetBuilder> routes = {
    // Rota inicial aponta para a "casca" com a barra de navegação
    getRoute(AppRoute.timeline): (context) => const MainScreenShell(),
    
    // Rota de detalhes continua a funcionar para a navegação profunda
    getRoute(AppRoute.postDetail): (context) => const PostDetailScreen(),
    
    // As outras telas são carregadas dentro da shell, então não precisam
    // de uma entrada aqui, a menos que você queira acessá-las por um link direto.
    // Para simplificar, mantemos apenas o essencial.
  };
}
