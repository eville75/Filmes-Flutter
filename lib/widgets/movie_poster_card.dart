import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Core/RouteManager.dart';
import '../models/movie.dart';

class MoviePosterCard extends StatefulWidget {
  final Movie movie;
  const MoviePosterCard({super.key, required this.movie});

  @override
  State<MoviePosterCard> createState() => _MoviePosterCardState();
}

class _MoviePosterCardState extends State<MoviePosterCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String imageUrl = widget.movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
        : '';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.getRoute(AppRoute.postDetail),
            arguments: widget.movie.id,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovering
              ? (Matrix4.identity()..scale(1.03))
              : Matrix4.identity(),
          child: Hero(
            tag: 'poster-${widget.movie.id}',
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: _isHovering ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagem de fundo
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: theme.colorScheme.surface,
                      highlightColor: theme.scaffoldBackgroundColor,
                      child: Container(color: theme.colorScheme.surface),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surface,
                      child: const Icon(Icons.movie_creation_outlined),
                    ),
                  ),
                  // "Footer" com efeito de vidro fosco
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          color: Colors.black.withOpacity(0.4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título do Filme
                              Text(
                                widget.movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  shadows: [
                                    Shadow(blurRadius: 2, color: Colors.black87)
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              // AVALIAÇÃO (ADICIONADA DE VOLTA)
                              Row(
                                children: [
                                  Icon(Icons.star_rate_rounded,
                                      color: Colors.amber.shade600, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.movie.voteAverage.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(blurRadius: 2, color: Colors.black87)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
