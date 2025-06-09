import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';
import '../widgets/movie_poster_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<Movie>> _fetchFavoriteMovies(List<int> movieIds) {
    final List<Future<Movie>> futureMovies =
        movieIds.map((id) => ApiService.fetchMovieDetails(id)).toList();
    return Future.wait(futureMovies);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds =
        Provider.of<FavoritesProvider>(context).favoriteMovieIds;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: favoriteIds.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_outline, size: 80, color: theme.textTheme.bodySmall?.color),
                    const SizedBox(height: 16),
                    Text(
                      'A sua lista de favoritos está vazia',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vá para a tela de detalhes de um filme para adicioná-lo aqui.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
              ),
            )
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
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200, childAspectRatio: 0.68,
                      crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MoviePosterCard(movie: movies[index]);
                  },
                );
              },
            ),
    );
  }
}
