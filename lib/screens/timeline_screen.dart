// screens/timeline_screen.dart

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _initialLoading = true; // Controla o primeiro carregamento
  bool _hasMore = true;
  String? _error; // Armazena a mensagem de erro
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      final newMovies = await ApiService.fetchPopularMovies(page: _currentPage);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Falha ao conectar com o servidor. Verifique sua conexão.';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _initialLoading = false; // Marca que o primeiro carregamento terminou
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _fetchMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _movies.clear();
      _currentPage = 1;
      _error = null;
      _hasMore = true;
      _initialLoading = true;
    });
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Populares'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 1. Estado de Carregamento Inicial
    if (_initialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Estado de Erro
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _retry,
                child: const Text('Tentar Novamente'),
              )
            ],
          ),
        ),
      );
    }

    // 3. Estado Vazio
    if (_movies.isEmpty) {
      return const Center(child: Text('Nenhum filme popular foi encontrado.'));
    }

    // 4. Estado de Sucesso (Lista de Filmes)
    return ListView.builder(
      controller: _scrollController,
      itemCount: _movies.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _movies.length) {
          // Card do Filme
          return MovieCard(movie: _movies[index]);
        } else {
          // Indicador de carregamento para rolagem infinita
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}