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
  // ... (a lógica interna permanece a mesma) ...
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _results = [];
  bool _isLoading = false;
  String? _error;
  bool _searchAttempted = false;

  Future<void> _performSearch() async {
    FocusScope.of(context).unfocus();
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _searchAttempted = true;
    });

    try {
      final movies = await ApiService.searchMovies(_searchController.text.trim());
      setState(() => _results = movies);
    } catch (e) {
      setState(() => _error = "Falha ao realizar a busca. Tente novamente.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Filmes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Digite o nome do filme...',
                prefixIcon: Icon(Icons.search, color: theme.hintColor),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => _performSearch(),
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    // ... (a lógica interna permanece a mesma) ...
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
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: _results[index]);
      },
    );
  }
}
