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
  bool _showPlayer = false;

  static const Map<int, String> _genreMap = {
    28: 'Ação', 12: 'Aventura', 16: 'Animação', 35: 'Comédia', 80: 'Crime',
    99: 'Documentário', 18: 'Drama', 10751: 'Família', 14: 'Fantasia', 36: 'História',
    27: 'Terror', 10402: 'Música', 9648: 'Mistério', 10749: 'Romance',
    878: 'Ficção Científica', 10770: 'Filme de TV', 53: 'Suspense', 10752: 'Guerra', 37: 'Faroeste'
  };

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

  void _initializeAndPlayYoutube(String? trailerKey) {
    if (trailerKey == null || _youtubeController != null) return;
    _youtubeController = YoutubePlayerController(
      initialVideoId: trailerKey,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    setState(() => _showPlayer = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Erro ao carregar filme: ${snapshot.error}'));
          }

          final movie = snapshot.data!;
          return buildContent(movie);
        },
      ),
    );
  }

  Widget buildContent(Movie movie) {
    final theme = Theme.of(context);
    final String imageUrl = movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w780${movie.posterPath}'
        : '';
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'poster-${movie.id}',
                child: Container(
                  width: double.infinity,
                  height: 280,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.scaffoldBackgroundColor, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      stops: const [0, 0.5],
                    ),
                  ),
                  child: _showPlayer && _youtubeController != null
                    ? YoutubePlayer(controller: _youtubeController!)
                    : imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Container(color: Colors.grey.shade800),
                ),
              ),
              if (!_showPlayer && movie.trailerKey != null)
                GestureDetector(
                  onTap: () => _initializeAndPlayYoutube(movie.trailerKey!),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
                  ),
                ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, child) {
                    final isFavorite = favoritesProvider.isFavorite(movie.id);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red.shade400 : theme.iconTheme.color,
                          ),
                          onPressed: () {
                            favoritesProvider.toggleFavorite(movie.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isFavorite ? 'Removido dos favoritos' : 'Adicionado aos favoritos!'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: isFavorite ? Colors.red.shade400 : Colors.green.shade600,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildGenreChips(movie.genreIds, theme),
                const SizedBox(height: 24),
                _buildInfoRow(movie, theme),
                const SizedBox(height: 24),
                _buildSynopsisDivider(theme),
                const SizedBox(height: 12),
                Text(
                  movie.overview.isNotEmpty ? movie.overview : 'Sinopse não disponível.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Movie movie, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(movie.voteAverage.toStringAsFixed(1), style: theme.textTheme.titleMedium),
        const SizedBox(width: 24),
        Icon(Icons.calendar_today_outlined, color: theme.hintColor, size: 18),
        const SizedBox(width: 8),
        Text(movie.releaseDate, style: theme.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildSynopsisDivider(ThemeData theme) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Sinopse", style: theme.textTheme.titleSmall?.copyWith(color: theme.hintColor)),
        ),
        const Expanded(child: Divider(thickness: 0.5)),
      ],
    );
  }

  Widget _buildGenreChips(List<int> genreIds, ThemeData theme) {
    final genres = genreIds.map((id) => _genreMap[id]).where((name) => name != null).toList();
    if (genres.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: genres.map((genre) => Chip(
        label: Text(genre!),
        backgroundColor: theme.chipTheme.backgroundColor,
        labelStyle: theme.chipTheme.labelStyle,
        side: BorderSide(color: theme.chipTheme.labelStyle?.color?.withOpacity(0.3) ?? Colors.transparent),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      )).toList(),
    );
  }
}
