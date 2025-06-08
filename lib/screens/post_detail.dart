
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  YoutubePlayerController? _youtubeController;

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
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initializeYoutubeController(String trailerKey) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: trailerKey,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: _movieFuture,
      builder: (context, snapshot) {
        final movie = snapshot.data;
        if (movie?.trailerKey != null && _youtubeController == null) {
          _initializeYoutubeController(movie!.trailerKey!);
        }

        return Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final isFavorite = movie != null && favoritesProvider.isFavorite(movie.id);

            return Scaffold(
              body: buildBody(snapshot, isFavorite, favoritesProvider),
            );
          },
        );
      },
    );
  }

  Widget buildBody(AsyncSnapshot<Movie> snapshot, bool isFavorite, FavoritesProvider favoritesProvider) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError || !snapshot.hasData) {
      return Center(child: Text('Erro ao carregar filme: ${snapshot.error}'));
    }

    final movie = snapshot.data!;
    final theme = Theme.of(context);
    final String imageUrl = movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w780${movie.posterPath}'
        : '';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: true,
          floating: false,
          elevation: 4,
          backgroundColor: theme.scaffoldBackgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              movie.title,
              style: TextStyle(fontSize: 16, shadows: [
                Shadow(blurRadius: 4, color: Colors.black.withOpacity(0.7))
              ]),
            ),
            background: Hero(
              tag: 'poster-${movie.id}',
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Container(color: Colors.grey),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red.shade400 : null,
              ),
              onPressed: () => favoritesProvider.toggleFavorite(movie.id),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_youtubeController != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trailer', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: YoutubePlayer(controller: _youtubeController!),
                        ),
                      ],
                    ),
                  ),

                Text('Sinopse', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isNotEmpty ? movie.overview : 'Sinopse não disponível.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoChip(Icons.calendar_today, 'Lançamento', movie.releaseDate, theme),
                    _buildInfoChip(Icons.star, 'Nota', movie.voteAverage.toStringAsFixed(1), theme),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.secondary, size: 28),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
