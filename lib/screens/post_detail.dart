// screens/post_detail.dart

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Future<Movie>? _movieFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final movieId = ModalRoute.of(context)!.settings.arguments as int?;
    if (movieId != null && _movieFuture == null) {
      _movieFuture = ApiService.fetchMovieDetails(movieId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: FutureBuilder<Movie>(
        future: _movieFuture,
        builder: (context, snapshot) {
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
          
          // LÓGICA DE RESPONSIVIDADE COMEÇA AQUI
          // Verifica a largura da tela para decidir qual layout usar
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) { // Se a tela for larga (tablet/desktop)
                return _buildWideLayout(movie);
              } else { // Se a tela for estreita (celular)
                return _buildNarrowLayout(movie);
              }
            },
          );
        },
      ),
    );
  }

  // Layout para telas estreitas (Celular)
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

  // Layout para telas largas (Tablet/Desktop)
  Widget _buildWideLayout(Movie movie) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coluna da Imagem
            Flexible(
              flex: 1,
              child: _buildMovieImage(movie, height: 500),
            ),
            const SizedBox(width: 24),
            // Coluna dos Detalhes
            Flexible(
              flex: 2,
              child: _buildMovieDetails(movie, isWide: true),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizável para a imagem
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

  // Widget reutilizável para os detalhes em texto
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