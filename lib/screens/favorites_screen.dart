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
  // ... (a lógica interna permanece a mesma) ...
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_filter_outlined, size: 80, color: Colors.grey.shade600),
                  const SizedBox(height: 16),
                  Text(
                    'Sua lista está vazia',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Marque filmes com uma estrela para adicioná-los aqui.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<Movie>>(
              future: _fetchFavoriteMovies(favoriteIds),
              builder: (context, snapshot) {
                // ... (a lógica interna permanece a mesma) ...
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
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
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
