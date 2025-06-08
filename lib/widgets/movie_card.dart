// widgets/movie_card.dart

import 'package:flutter/material.dart';
import '../Core/RouteManager.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : 'https://via.placeholder.com/150x225';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      // O InkWell deve estar aqui para que o Card seja clicável
      child: InkWell(
        borderRadius: BorderRadius.circular(12), // Para o efeito de clique ter bordas arredondadas
        onTap: () {
          // Esta é a linha que faz o redirecionamento.
          // Ela deve funcionar se a rota 'postDetail' estiver correta no RouteManager.
          Navigator.pushNamed(
            context,
            AppRoutes.getRoute(AppRoute.postDetail),
            arguments: movie.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          // Usando uma Row para alinhar imagem e texto lado a lado
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do Filme com tamanho fixo
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  width: 100, // Largura fixa
                  height: 150, // Altura fixa para manter a proporção
                  fit: BoxFit.cover, // Garante que a imagem cubra o espaço sem distorcer
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Expanded garante que o texto ocupe o espaço restante
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      // Permite que o texto tenha no máximo 3 linhas
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}