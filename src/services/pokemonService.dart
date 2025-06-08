import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

const String baseUrl = 'https://pokeapi.co/api/v2';
const String spriteBaseUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon';

Future<List<Pokemon>> fetchPokemons({int offset = 0, int limit = 20}) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar Pokémons: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    final pokemons = await Future.wait(results.map((pokemon) async {
      final urlParts = (pokemon['url'] as String).split('/');
      final id = int.parse(urlParts[urlParts.length - 2]);

      try {
        final detailResponse = await http.get(Uri.parse('$baseUrl/pokemon/$id'));

        if (detailResponse.statusCode == 200) {
          final details = jsonDecode(detailResponse.body);
          final types = (details['types'] as List)
              .map<String>((t) => t['type']['name'] as String)
              .toList();

          return Pokemon(
            id: id,
            name: pokemon['name'],
            imageUrl: '$spriteBaseUrl/$id.png',
            types: types,
            height: (details['height'] as int) / 10,
            weight: (details['weight'] as int) / 10,
          );
        }
      } catch (e) {
        print('Erro ao buscar detalhes do Pokémon #$id: $e');
      }

      // Fallback
      return Pokemon(
        id: id,
        name: pokemon['name'],
        imageUrl: '$spriteBaseUrl/$id.png',
      );
    }));

    return pokemons;
  } catch (e) {
    print('Erro geral ao buscar Pokémons: $e');
    rethrow;
  }
}
