import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Core/RouteManager.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';

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

// A CLASSE MainApp PRECISA DESTE MÉTODO 'build' DENTRO DELA
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Filmes Populares',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xFFF3F4F6),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.teal,
            ),
          ),
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              scaffoldBackgroundColor: const Color.fromARGB(255, 18, 27, 34),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 25, 39, 45),
              ),
              cardTheme:
                  const CardTheme(color: Color.fromARGB(255, 25, 39, 45)),
              iconButtonTheme: IconButtonThemeData(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.white)))),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.getRoute(AppRoute.timeline),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}