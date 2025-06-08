class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String? trailerKey; // <-- NOVO CAMPO PARA A CHAVE DO TRAILER

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    this.trailerKey, // <-- NOVO PARÂMETRO
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Lógica para encontrar a melhor chave de trailer na resposta da API
    String? key;
    if (json['videos'] != null && json['videos']['results'].isNotEmpty) {
      final videos = json['videos']['results'] as List;
      final officialTrailer = videos.firstWhere(
        (video) => video['type'] == 'Trailer' && video['official'] == true,
        orElse: () => null,
      );
      
      if (officialTrailer != null) {
        key = officialTrailer['key'];
      } else {
        // Se não houver trailer oficial, pega o primeiro trailer que encontrar
        final anyTrailer = videos.firstWhere(
          (video) => video['type'] == 'Trailer',
          orElse: () => null,
        );
        if (anyTrailer != null) {
          key = anyTrailer['key'];
        }
      }
    }

    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? 'N/A',
      voteAverage: (json['vote_average'] as num).toDouble(),
      trailerKey: key, // <-- ATRIBUINDO A CHAVE
    );
  }
}
