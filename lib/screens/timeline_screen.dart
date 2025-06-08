import 'package:flutter/material.dart';
import '../Core/RouteManager.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';

// Enum para controlar o tipo de filtro de forma segura
enum MovieSortOrder {
  popular,
  topRated,
  nowPlaying,
}

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  // Variáveis de estado
  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _initialLoading = true;
  bool _hasMore = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  
  // NOVA VARIÁVEL DE ESTADO: Guarda o filtro atual
  MovieSortOrder _currentSortOrder = MovieSortOrder.popular;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _scrollController.addListener(_onScroll);
  }

  // ATUALIZADO: Agora busca filmes com base no filtro
  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      Future<List<Movie>> future;
      // Decide qual função da API chamar com base no filtro
      switch (_currentSortOrder) {
        case MovieSortOrder.topRated:
          future = ApiService.fetchTopRatedMovies(page: _currentPage);
          break;
        case MovieSortOrder.nowPlaying:
          future = ApiService.fetchNowPlayingMovies(page: _currentPage);
          break;
        case MovieSortOrder.popular:
        default:
          future = ApiService.fetchPopularMovies(page: _currentPage);
          break;
      }

      final newMovies = await future;
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (e) {
      setState(() => _error = 'Falha ao conectar. Verifique sua conexão.');
    } finally {
      setState(() {
        _isLoading = false;
        _initialLoading = false;
      });
    }
  }

  // NOVO: Função para trocar o filtro e recarregar a lista
  void _changeSortOrder(MovieSortOrder newOrder) {
    if (_currentSortOrder == newOrder) return; // Não faz nada se o filtro for o mesmo

    setState(() {
      _currentSortOrder = newOrder;
      _movies.clear();
      _currentPage = 1;
      _hasMore = true;
      _initialLoading = true;
      _error = null;
    });
    _fetchMovies(); // Busca os filmes com o novo filtro
  }

  // ATUALIZADO: O título da tela agora é dinâmico
  String get _appBarTitle {
    switch (_currentSortOrder) {
      case MovieSortOrder.topRated:
        return 'Mais Bem Avaliados';
      case MovieSortOrder.nowPlaying:
        return 'Em Cartaz';
      case MovieSortOrder.popular:
      default:
        return 'Filmes Populares';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.pushNamed(context, AppRoutes.getRoute(AppRoute.search))),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => Navigator.pushNamed(context, AppRoutes.getRoute(AppRoute.favorites))),
          // NOVO: Botão de Menu para os Filtros
          PopupMenuButton<MovieSortOrder>(
            icon: const Icon(Icons.filter_list),
            onSelected: _changeSortOrder,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MovieSortOrder>>[
              const PopupMenuItem<MovieSortOrder>(
                value: MovieSortOrder.popular,
                child: Text('Populares'),
              ),
              const PopupMenuItem<MovieSortOrder>(
                value: MovieSortOrder.topRated,
                child: Text('Melhores Avaliações'),
              ),
              const PopupMenuItem<MovieSortOrder>(
                value: MovieSortOrder.nowPlaying,
                child: Text('Lançamentos Recentes'),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, AppRoutes.getRoute(AppRoute.settings))),
        ],
      ),
      body: _buildBody(),
    );
  }

  // O resto do arquivo (_onScroll, dispose, _retry, _buildBody) continua o mesmo.
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
      return const Center(child: Text('Nenhum filme encontrado para este filtro.'));
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