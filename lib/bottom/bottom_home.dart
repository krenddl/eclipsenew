import 'package:easy_stars/easy_stars.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';
import 'package:eclipce_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GenreFilter {
  const GenreFilter({
    required this.id,
    required this.title,
  });

  final dynamic id;
  final String title;
}

class BottomHomePage extends StatefulWidget {
  const BottomHomePage({super.key});

  @override
  State<BottomHomePage> createState() => _BottomHomePageState();
}

class _BottomHomePageState extends State<BottomHomePage> {
  final String userId = Supabase.instance.client.auth.currentUser!.id;
  final FavotireTable favotireTable = FavotireTable();
  final PageController _pageController = PageController(viewportFraction: 0.78);

  late final Future<List<GenreFilter>> _genresFuture = _loadGenres();

  int _currentPage = 0;
  GenreFilter? _selectedGenre;

  Widget topPoster(BuildContext context, dynamic docs) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MovieInfoPage(docs: docs),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(docs['image']),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget genreChip(GenreFilter genre, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGenre = genre;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.deepPurpleAccent : Colors.white12,
          ),
        ),
        child: Text(
          genre.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget movieTile(BuildContext context, dynamic docs, bool isFavorite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MovieInfoPage(docs: docs),
              ),
            ),
            child: Container(
              width: 78,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: NetworkImage(docs['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MovieInfoPage(docs: docs),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    docs['name'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      EasyStarsRating(
                        initialRating: double.parse(docs['stars'].toString()),
                        filledColor: Colors.deepPurple,
                        emptyColor: Colors.white24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        docs['stars'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    docs['descriptiion'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              if (isFavorite) {
                await favotireTable.deleteFavourite(userId, docs['id']);
              } else {
                await favotireTable.addFavourite(userId, docs);
              }
            },
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: isFavorite ? Colors.deepPurple : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<GenreFilter>> _loadGenres() async {
    final supabase = Supabase.instance.client;
    final candidates = ['genre', 'genres', 'category', 'categories'];

    for (final table in candidates) {
      try {
        final response = await supabase.from(table).select();
        if (response is! List || response.isEmpty) {
          continue;
        }

        final genres = response.map<GenreFilter?>((item) {
          if (item is! Map<String, dynamic>) return null;

          final id =
              item['id'] ??
              item['genre_id'] ??
              item['category_id'] ??
              item['movie_genre_id'];
          final title =
              item['name'] ??
              item['title'] ??
              item['genre'] ??
              item['category'];

          if (id == null || title == null) return null;

          final normalizedTitle = title.toString().trim();
          if (normalizedTitle.isEmpty) return null;

          return GenreFilter(
            id: id,
            title: normalizedTitle,
          );
        }).whereType<GenreFilter>().toList();

        if (genres.isNotEmpty) {
          return [
            const GenreFilter(id: null, title: 'Все'),
            ...genres,
          ];
        }
      } catch (_) {
        continue;
      }
    }

    return const [GenreFilter(id: null, title: 'Все')];
  }

  bool _matchesSelectedGenre(dynamic movie) {
    final selectedGenre = _selectedGenre;
    if (selectedGenre == null || selectedGenre.id == null) {
      return true;
    }

    final selectedId = selectedGenre.id.toString().toLowerCase();
    final selectedTitle = selectedGenre.title.toLowerCase();

    bool containsValue(dynamic value, String target) {
      if (value == null) return false;

      if (value is List) {
        return value.any((item) => containsValue(item, target));
      }

      if (value is Map) {
        return value.values.any((item) => containsValue(item, target));
      }

      return value.toString().toLowerCase() == target;
    }

    final candidateFields = [
      movie['genre_id'],
      movie['genres_id'],
      movie['category_id'],
      movie['id_genre'],
      movie['id_category'],
      movie['genre'],
      movie['genres'],
      movie['category'],
      movie['categories'],
    ];

    return candidateFields.any((field) => containsValue(field, selectedId)) ||
        candidateFields.any((field) => containsValue(field, selectedTitle));
  }

  List<dynamic> _filterMovies(List<dynamic> movies) {
    return movies.where(_matchesSelectedGenre).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120B1E),
      body: SafeArea(
        child: FutureBuilder<List<GenreFilter>>(
          future: _genresFuture,
          builder: (context, genreSnapshot) {
            final genres =
                genreSnapshot.data ?? const [GenreFilter(id: null, title: 'Все')];

            if (_selectedGenre == null && genres.isNotEmpty) {
              _selectedGenre = genres.first;
            } else if (_selectedGenre != null &&
                !genres.any((genre) => genre.id == _selectedGenre!.id)) {
              _selectedGenre = genres.first;
            }

            return StreamBuilder(
              stream: Supabase.instance.client
                  .from('favourites')
                  .stream(primaryKey: ['id'])
                  .eq('id_user', userId),
              builder: (context, snapshotFav) {
                if (!snapshotFav.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  );
                }

                final favorites = snapshotFav.data!;
                final favoriteIds = favorites.map((e) => e['id_movie']).toSet();

                return StreamBuilder(
                  stream: Supabase.instance.client
                      .from('movie')
                      .stream(primaryKey: ['id']),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    }

                    final movies = snapshot.data!;

                    if (movies.isEmpty) {
                      return const Center(
                        child: Text(
                          'Фильмы не найдены',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final filteredMovies = _filterMovies(movies);
                    final featuredMovies = movies.take(5).toList();
                    final currentFeaturedMovie = featuredMovies[
                        _currentPage.clamp(0, featuredMovies.length - 1)];

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 290,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: featuredMovies.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final docs = featuredMovies[index];

                                  return AnimatedPadding(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeOut,
                                    padding: EdgeInsets.only(
                                      right: 12,
                                      top: _currentPage == index ? 0 : 12,
                                      bottom: _currentPage == index ? 0 : 12,
                                    ),
                                    child: topPoster(context, docs),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(featuredMovies.length, (
                                index,
                              ) {
                                final selected = index == _currentPage;

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: selected ? 22 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.deepPurple
                                        : Colors.white24,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Container(
                                width: 140,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6D9F3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => MovieInfoPage(
                                          docs: currentFeaturedMovie,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Смотреть',
                                    style: TextStyle(
                                      color: Color(0xFF2D1939),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Сейчас в топе',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 40,
                              child: genreSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const Center(
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    )
                                  : ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: genres
                                          .map(
                                            (genre) => genreChip(
                                              genre,
                                              selected:
                                                  _selectedGenre?.id == genre.id,
                                            ),
                                          )
                                          .toList(),
                                    ),
                            ),
                            const SizedBox(height: 20),
                            if (filteredMovies.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: Text(
                                    'По выбранному жанру ничего не найдено',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                itemCount: filteredMovies.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final docs = filteredMovies[index];
                                  final isFavorite = favoriteIds.contains(
                                    docs['id'],
                                  );

                                  return movieTile(context, docs, isFavorite);
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
