// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String _apiKey = '8e15ccb77230bca820dbc71b74768495';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _language = 'pt-BR';

  // Função para buscar a lista de filmes populares (sem alteração)
  static Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=$_language&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar filmes populares');
    }
  }

  // NOVA FUNÇÃO: Busca os detalhes de um filme específico
  static Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$_language'));

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }
}