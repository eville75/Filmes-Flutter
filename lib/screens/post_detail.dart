import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Future<Movie>? _movieFuture;
  int? _movieId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final receivedId = ModalRoute.of(context)!.settings.arguments as int?;
    if (receivedId != null && _movieId == null) {
      _movieId = receivedId;
      _movieFuture = ApiService.fetchMovieDetails(_movieId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: _movieFuture,
      builder: (context, snapshot) {
        final movie = snapshot.data;
        // O Consumer ouve as mudanças no FavoritesProvider
        return Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final isFavorite = movie != null && favoritesProvider.isFavorite(movie.id);

            return Scaffold(
              appBar: AppBar(
                title: Text(movie?.title ?? 'Detalhes'),
                actions: [
                  // Apenas mostra o botão se o filme tiver carregado
                  if (movie != null)
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.amber : null,
                      ),
                      onPressed: () {
                        // Chama a função para favoritar/desfavoritar
                        favoritesProvider.toggleFavorite(movie.id);
                      },
                    ),
                ],
              ),
              body: buildBody(snapshot),
            );
          },
        );
      },
    );
  }

  // O corpo da tela continua o mesmo, só o separamos em uma função
  Widget buildBody(AsyncSnapshot<Movie> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError || !snapshot.hasData) {
      return Center(
        child: Text(
          'Não foi possível carregar os detalhes do filme.\n${snapshot.error ?? ''}',
          textAlign: TextAlign.center,
        ),
      );
    }
    final movie = snapshot.data!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          return _buildWideLayout(movie);
        } else {
          return _buildNarrowLayout(movie);
        }
      },
    );
  }

  // As funções _buildWideLayout, _buildNarrowLayout, _buildMovieImage
  // e _buildMovieDetails continuam aqui, sem nenhuma alteração.
  // (O código que você já tinha)
   Widget _buildNarrowLayout(Movie movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMovieImage(movie, height: 350),
          _buildMovieDetails(movie, isWide: false),
        ],
      ),
    );
  }

  Widget _buildWideLayout(Movie movie) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: _buildMovieImage(movie, height: 500),
            ),
            const SizedBox(width: 24),
            Flexible(
              flex: 2,
              child: _buildMovieDetails(movie, isWide: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieImage(Movie movie, {required double height}) {
    final String imageUrl = movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : 'https://via.placeholder.com/400x600';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie, {required bool isWide}) {
    return Padding(
      padding: isWide ? EdgeInsets.zero : const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: TextStyle(
              fontSize: isWide ? 32 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Lançamento: ${movie.releaseDate}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Nota: ${movie.voteAverage.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Sinopse',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.overview.isNotEmpty ? movie.overview : 'Sinopse não disponível.',
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}