// ADICIONE ESTAS DUAS LINHAS IMPORTANTES
import 'package:flutter/material.dart';
import '../Core/RouteManager.dart';

// O resto do seu código que estava correto...
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
  bool _initialLoading = true;
  bool _hasMore = true;
  String? _error;
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
        _initialLoading = false;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.getRoute(AppRoute.about));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(
                  context, AppRoutes.getRoute(AppRoute.settings));
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
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

    if (_movies.isEmpty) {
      return const Center(child: Text('Nenhum filme popular foi encontrado.'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _movies.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _movies.length) {
          return MovieCard(movie: _movies[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}