import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../Core/RouteManager.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/movie_poster_card.dart';

enum MovieSortOrder { popular, topRated, nowPlaying }

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
  MovieSortOrder _currentSortOrder = MovieSortOrder.popular;

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
      Future<List<Movie>> future;
      switch (_currentSortOrder) {
        case MovieSortOrder.topRated:
          future = ApiService.fetchTopRatedMovies(page: _currentPage);
          break;
        case MovieSortOrder.nowPlaying:
          future = ApiService.fetchNowPlayingMovies(page: _currentPage);
          break;
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
      setState(() => _error = 'Falha ao conectar. Verifique a sua ligação.');
    } finally {
      setState(() {
        _isLoading = false;
        _initialLoading = false;
      });
    }
  }

  void _changeSortOrder(MovieSortOrder newOrder) {
    if (_currentSortOrder == newOrder) return;
    setState(() {
      _currentSortOrder = newOrder;
      _movies.clear();
      _currentPage = 1;
      _hasMore = true;
      _initialLoading = true;
      _error = null;
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    });
    _fetchMovies();
  }

  // ATUALIZADO: Títulos conforme a sua sugestão
  String get _currentFilterTitle {
    switch (_currentSortOrder) {
      case MovieSortOrder.topRated:
        return 'Melhor Avaliação';
      case MovieSortOrder.nowPlaying:
        return 'Lançado Recentemente';
      case MovieSortOrder.popular:
      return 'Em Alta';
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400 &&
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              centerTitle: false,
              title: AppLogo(size: 24),
              background: Center(child: AppLogo(size: 40)),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.getRoute(AppRoute.search))),
              IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.getRoute(AppRoute.favorites))),
              // ATUALIZADO: Textos do menu de filtro
              PopupMenuButton<MovieSortOrder>(
                icon: const Icon(Icons.filter_list),
                onSelected: _changeSortOrder,
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MovieSortOrder>>[
                  const PopupMenuItem<MovieSortOrder>(
                      value: MovieSortOrder.popular, child: Text('Em Alta')),
                  const PopupMenuItem<MovieSortOrder>(
                      value: MovieSortOrder.topRated,
                      child: Text('Melhor Avaliação')),
                  const PopupMenuItem<MovieSortOrder>(
                      value: MovieSortOrder.nowPlaying,
                      child: Text('Lançado Recentemente')),
                ],
              ),
              IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.getRoute(AppRoute.settings))),
            ],
          ),
          
          // NOVO: Adicionamos este widget para exibir o título do filtro
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                _currentFilterTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) {
      return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return SliverFillRemaining(
          child: Center(
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
                  onPressed: _retry, child: const Text('Tentar Novamente'))
            ]),
      )));
    }
    if (_movies.isEmpty) {
      return const SliverFillRemaining(
          child: Center(child: Text('Nenhum filme encontrado para este filtro.')));
    }

    return SliverPadding(
      padding: const EdgeInsets.all(12.0),
      sliver: AnimationLimiter(
        child: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= _movies.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 400),
                columnCount: (MediaQuery.of(context).size.width / 200).floor(),
                child: ScaleAnimation(
                    child: FadeInAnimation(
                        child: MoviePosterCard(movie: _movies[index]))),
              );
            },
            childCount: _movies.length + (_hasMore ? 1 : 0),
          ),
        ),
      ),
    );
  }
}
