import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'timeline_screen.dart';

class MainScreenShell extends StatefulWidget {
  const MainScreenShell({super.key});

  @override
  State<MainScreenShell> createState() => _MainScreenShellState();
}

class _MainScreenShellState extends State<MainScreenShell> {
  int _selectedIndex = 0;

  // Lista das telas que serão controladas pela barra de navegação
  static const List<Widget> _widgetOptions = <Widget>[
    TimelineScreen(),
    SearchScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Estilização da barra de navegação
        backgroundColor: theme.appBarTheme.backgroundColor,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.textTheme.bodySmall?.color,
        type: BottomNavigationBarType.fixed, // Garante que todos os itens apareçam
        showUnselectedLabels: true,
      ),
    );
  }
}
