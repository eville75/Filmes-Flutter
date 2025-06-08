import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Esta função busca os detalhes de todos os filmes favoritos
  Future<List<Movie>> _fetchFavoriteMovies(List<int> movieIds) {
    // Cria uma lista de Futures, onde cada Future é uma chamada à API
    final List<Future<Movie>> futureMovies = movieIds.map((id) {
      return ApiService.fetchMovieDetails(id);
    }).toList();

    // Future.wait aguarda que todas as chamadas à API terminem
    return Future.wait(futureMovies);
  }

  @override
  Widget build(BuildContext context) {
    // Ouve o FavoritesProvider para obter a lista de IDs
    final favoriteIds = Provider.of<FavoritesProvider>(context).favoriteMovieIds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: favoriteIds.isEmpty
          // Se não houver favoritos, mostra uma mensagem simples
          ? const Center(
              child: Text(
                'Você ainda não adicionou nenhum filme aos favoritos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          // Se houver favoritos, usa o FutureBuilder para buscá-los e exibi-los
          : FutureBuilder<List<Movie>>(
              future: _fetchFavoriteMovies(favoriteIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar favoritos: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Não foi possível carregar os detalhes dos filmes.'));
                }

                final movies = snapshot.data!;
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: movies[index]);
                  },
                );
              },
            ),
    );
  }
}