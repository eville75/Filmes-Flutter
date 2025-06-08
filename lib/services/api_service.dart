// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String _apiKey = '8e15ccb77230bca820dbc71b74768495';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _language = 'pt-BR';

  // ... (outras funções fetch sem alteração) ...

  static Future<Movie> fetchMovieDetails(int movieId) async {
    // ATUALIZADO: Adicionamos 'append_to_response=videos' para buscar os trailers
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$_language&append_to_response=videos'));
        
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }

  // ... (O resto do arquivo ApiService continua igual)
    static Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/popular?api_key=$_apiKey&language=$_language&page=$page'));
    return _parseMovies(response);
  }

  static Future<List<Movie>> searchMovies(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=$_language&query=$encodedQuery'));
    return _parseMovies(response);
  }

  static Future<List<Movie>> fetchTopRatedMovies({int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=$_language&page=$page'));
    return _parseMovies(response);
  }

  static Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$_language&page=$page'));
    return _parseMovies(response);
  }

  static List<Movie> _parseMovies(http.Response response) {
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar a lista de filmes');
    }
  }
}
