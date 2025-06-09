import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Core/RouteManager.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';

// Definindo as cores da sua paleta para fácil acesso
class AppColors {
  // Cores Modo Claro
  static const Color lightBg = Color(0xFFF9F9F9);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF1976D2);
  static const Color lightText = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF555555);

  // Cores Modo Escuro
  static const Color darkBg = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF90CAF9);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBBBBBB);
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
          title: 'CineApp',
          themeMode: themeProvider.themeMode,
          
          // TEMA MODO CLARO
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            primaryColor: AppColors.lightPrimary,
            colorScheme: const ColorScheme.light(
              primary: AppColors.lightPrimary,
              secondary: AppColors.lightPrimary,
              onPrimary: Colors.white,
              surface: AppColors.lightCard,
            ),
            cardTheme: const CardTheme(
              color: AppColors.lightCard,
              elevation: 2,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightBg,
              foregroundColor: AppColors.lightText,
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: AppColors.lightText),
              bodySmall: TextStyle(color: AppColors.lightTextSecondary),
            ),
            chipTheme: const ChipThemeData(
              backgroundColor: Color(0xFFE3F2FD),
              labelStyle: TextStyle(color: AppColors.lightPrimary, fontWeight: FontWeight.w600),
            ),
            dividerTheme: const DividerThemeData(color: Colors.black12),
          ),

          // TEMA MODO ESCURO
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBg,
            primaryColor: AppColors.darkPrimary,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.darkPrimary,
              secondary: AppColors.darkPrimary,
              onPrimary: Colors.black,
              surface: AppColors.darkCard,
            ),
            cardTheme: const CardTheme(color: AppColors.darkCard),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkBg,
              foregroundColor: AppColors.darkText,
              elevation: 0,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: AppColors.darkText),
              bodySmall: TextStyle(color: AppColors.darkTextSecondary),
            ),
            chipTheme: const ChipThemeData(
              backgroundColor: Color(0xFF263238),
              labelStyle: TextStyle(color: AppColors.darkPrimary, fontWeight: FontWeight.w600),
            ),
            dividerTheme: const DividerThemeData(color: Colors.white12),
          ),

          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.getRoute(AppRoute.timeline),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
