// lib/services/api_service.dart

// 1. IMPORTS ESSENCIAIS QUE ESTAVAM FALTANDO
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  // 2. VARIÁVEIS DA CLASSE
  static const String _apiKey = '8e15ccb77230bca820dbc71b74768495';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _language = 'pt-BR';

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

  static Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$_language'));

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }

  // 3. A FUNÇÃO DE BUSCA DEVE ESTAR AQUI DENTRO DO '}' DA CLASSE
  static Future<List<Movie>> searchMovies(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=$_language&query=$encodedQuery'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar filmes');
    }
  }
} // <-- FIM DA CLASSE ApiService