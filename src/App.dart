import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:your_app/pages/index.dart';
import 'package:your_app/pages/design_system.dart';
import 'package:your_app/pages/not_found.dart';
import 'package:overlay_support/overlay_support.dart'; // Para toasts

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const IndexPage()),
    GoRoute(path: '/design-system', builder: (context, state) => const DesignSystemPage()),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp.router(
        title: 'Seu App',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: _router,
      ),
    );
  }
}
