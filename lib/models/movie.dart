// Este arquivo não deve ter nenhum import do 'material.dart' ou de rotas.
// Apenas a definição da classe.

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String? trailerKey;
  final List<int> genreIds;
  
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    this.trailerKey,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String? key;
    if (json['videos'] != null && json['videos']['results'].isNotEmpty) {
      final videos = json['videos']['results'] as List;
      final officialTrailer = videos.firstWhere(
        (video) => video['type'] == 'Trailer' && video['official'] == true,
        orElse: () => videos.firstWhere((video) => video['type'] == 'Trailer', orElse: () => null),
      );
      if (officialTrailer != null) { key = officialTrailer['key']; }
    }
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Título Desconhecido',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? 'N/A',
      voteAverage: (json['vote_average'] as num? ?? 0.0).toDouble(),
      trailerKey: key,
      genreIds: List<int>.from(json['genre_ids'] ?? (json['genres'] as List? ?? []).map((g) => g['id'])),
    );
  }
}
