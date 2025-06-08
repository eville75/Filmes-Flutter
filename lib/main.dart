import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Core/RouteManager.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';

// Cores da nova paleta inspirada no TMDB
class AppColors {
  static const Color tmdbDarkBlue = Color(0xFF0d253f);
  static const Color tmdbLightBlue = Color(0xFF01b4e4);
  static const Color tmdbLighterGreen = Color(0xFF90cea1);
  static const Color almostBlack = Color(0xFF031d33);
  static const Color nearWhite = Color(0xFFF5F5F5);
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Filmes Populares',
          themeMode: themeProvider.themeMode,
          
          // NOVA PALETA - MODO CLARO
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.tmdbDarkBlue,
            scaffoldBackgroundColor: AppColors.nearWhite,
            colorScheme: const ColorScheme.light(
              primary: AppColors.tmdbDarkBlue,
              secondary: AppColors.tmdbLightBlue,
              onPrimary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.tmdbDarkBlue,
              foregroundColor: Colors.white,
            ),
          ),

          // NOVA PALETA - MODO ESCURO
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.tmdbLightBlue,
            scaffoldBackgroundColor: AppColors.almostBlack,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.tmdbLightBlue,
              secondary: AppColors.tmdbLighterGreen,
              surface: AppColors.tmdbDarkBlue, // Cor dos cards e dialogs
              onPrimary: Colors.black,
            ),
            cardTheme: const CardTheme(
              color: AppColors.tmdbDarkBlue,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.tmdbDarkBlue,
              foregroundColor: Colors.white,
            ),
          ),

          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.getRoute(AppRoute.timeline),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
