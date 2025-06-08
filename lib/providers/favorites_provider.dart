// lib/providers/favorites_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _favoritesKey = 'favoriteMovies';
  List<int> _favoriteMovieIds = [];

  // Construtor que carrega os favoritos assim que o provider é criado
  FavoritesProvider() {
    _loadFavorites();
  }

  List<int> get favoriteMovieIds => _favoriteMovieIds;

  // Carrega a lista de IDs salvos na memória do aparelho
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences só salva listas de Strings, então convertemos
    final favoriteIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteMovieIds = favoriteIdsAsString.map((id) => int.parse(id)).toList();
    notifyListeners();
  }

  // Adiciona ou remove um favorito e salva a alteração
  Future<void> toggleFavorite(int movieId) async {
    if (isFavorite(movieId)) {
      _favoriteMovieIds.remove(movieId);
    } else {
      _favoriteMovieIds.add(movieId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  // Salva a lista atual de IDs na memória
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Convertemos a lista de inteiros para uma lista de Strings para salvar
    final favoriteIdsAsString = _favoriteMovieIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteIdsAsString);
  }

  // Função simples para verificar se um filme já é favorito
  bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }
}