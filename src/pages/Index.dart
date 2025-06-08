import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/pokemon_timeline.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      body: SafeArea(
        child: Column(
          children: [
            const Header(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: const PokemonTimeline(),
              ),
            ),

            Container(
              color: const Color(0xFF2A75BB), // bg-pokemon-blue
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Poké-Scroll Showcase © $currentYear',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pokémon and Pokémon character names are trademarks of Nintendo',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
