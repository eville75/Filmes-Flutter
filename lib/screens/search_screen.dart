import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _results = [];
  bool _isLoading = false;
  String? _error;
  bool _searchAttempted = false;

  Future<void> _performSearch() async {
    // Esconde o teclado
    FocusScope.of(context).unfocus();

    if (_searchController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _searchAttempted = true;
    });

    try {
      final movies = await ApiService.searchMovies(_searchController.text.trim());
      setState(() {
        _results = movies;
      });
    } catch (e) {
      setState(() {
        _error = "Falha ao realizar a busca. Tente novamente.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Filmes'),
      ),
      body: Column(
        children: [
          // Campo de busca e botão
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Digite o nome do filme...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (value) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Área de resultados
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (!_searchAttempted) {
      return const Center(child: Text('Digite algo para buscar um filme.'));
    }

    if (_results.isEmpty) {
      return Center(child: Text('Nenhum resultado encontrado para "${_searchController.text}".'));
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: _results[index]);
      },
    );
  }
}