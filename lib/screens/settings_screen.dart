// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Provider.of para obter a instância do nosso ThemeProvider
    // e assim poder ler o estado atual (isDarkMode) e chamar a função (toggleTheme).
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // O SwitchListTile é um widget perfeito para opções liga/desliga.
            SwitchListTile(
              title: const Text('Modo Escuro'),
              subtitle: const Text('Ative para uma melhor experiência noturna'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                // Quando o usuário clica no interruptor,
                // chamamos a função para alterar o tema.
                themeProvider.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}