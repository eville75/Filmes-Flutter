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
  static const Color lightChip = Color(0xFFE3F2FD);

  // Cores Modo Escuro
  static const Color darkBg = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF90CAF9);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBBBBBB);
  static const Color darkChip = Color(0xFF263238);
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
          
          // TEMA MODO CLARO - Implementação da sua paleta
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            primaryColor: AppColors.lightPrimary,
            colorScheme: const ColorScheme.light(
              primary: AppColors.lightPrimary,
              secondary: AppColors.lightPrimary, // Usando a mesma cor de destaque
              onPrimary: Colors.white,
              surface: AppColors.lightCard,
            ),
            cardTheme: const CardTheme(
              color: AppColors.lightCard,
              elevation: 2,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.lightCard,
              foregroundColor: AppColors.lightText, // Cor do título e ícones
              elevation: 1,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: AppColors.lightText),
              bodySmall: TextStyle(color: AppColors.lightTextSecondary),
            ),
            chipTheme: const ChipThemeData(
              backgroundColor: AppColors.lightChip,
              labelStyle: TextStyle(color: AppColors.lightPrimary, fontWeight: FontWeight.w600),
            ),
            dividerTheme: const DividerThemeData(
              color: Colors.black12,
            )
          ),

          // TEMA MODO ESCURO - Implementação da sua paleta
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBg,
            primaryColor: AppColors.darkPrimary,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.darkPrimary,
              secondary: AppColors.darkPrimary, // Cor de destaque
              onPrimary: Colors.black,
              surface: AppColors.darkCard,
            ),
            cardTheme: const CardTheme(
              color: AppColors.darkCard,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkBg,
              foregroundColor: AppColors.darkText,
              elevation: 1,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: AppColors.darkText),
              bodySmall: TextStyle(color: AppColors.darkTextSecondary),
            ),
            chipTheme: const ChipThemeData(
              backgroundColor: AppColors.darkChip,
              labelStyle: TextStyle(color: AppColors.darkPrimary, fontWeight: FontWeight.w600),
            ),
            dividerTheme: const DividerThemeData(
              color: Colors.white12,
            )
          ),

          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.getRoute(AppRoute.timeline),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
