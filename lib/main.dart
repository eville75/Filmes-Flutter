// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Core/RouteManager.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    // 1. O Provider é criado aqui, no topo de tudo.
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(), // O nosso app agora é o MainApp
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Usamos o Consumer para que o MaterialApp se reconstrua ao mudar o tema
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // 3. O MaterialApp foi movido para cá
        return MaterialApp(
          title: 'Filmes Populares',
          // 4. A mágica acontece aqui: o tema é definido pelo Provider
          themeMode: themeProvider.themeMode,
          
          // TEMA PARA O MODO CLARO
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xFFF3F4F6),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.teal,
            ),
          ),

          // TEMA PARA O MODO ESCURO
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color.fromARGB(255, 18, 27, 34),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 25, 39, 45),
            ),
            cardTheme: const CardTheme(
              color: Color.fromARGB(255, 25, 39, 45),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white)
              )
            )
          ),

          debugShowCheckedModeBanner: false,
          // 5. As rotas continuam vindo do AppRoutes
          initialRoute: AppRoutes.getRoute(AppRoute.timeline),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}