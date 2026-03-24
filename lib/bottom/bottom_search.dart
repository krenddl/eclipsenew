import 'package:easy_stars/easy_stars.dart';
import 'package:eclipce_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';

class BottomSearchPage extends StatefulWidget {
  const BottomSearchPage({super.key});

  @override
  State<BottomSearchPage> createState() => _BottomSearchPageState();
}

class _BottomSearchPageState extends State<BottomSearchPage> {
  final TextEditingController searchController = TextEditingController();
  final FavotireTable favotireTable = FavotireTable();
  final String userId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget movieTile(BuildContext context, dynamic docs, bool isFavorite) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            docs['image'],
            width: 55,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 55,
                height: 80,
                color: Colors.white10,
                child: const Icon(Icons.movie, color: Colors.white),
              );
            },
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              docs['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            EasyStarsRating(
              initialRating: double.parse(docs['stars'].toString()),
              filledColor: Colors.deepPurple,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            docs['descriptiion'],
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: IconButton(
          onPressed: () async {
            await favotireTable.toggleFavourite(userId, docs);
          },
          icon: Icon(
            isFavorite ? Icons.bookmark : Icons.bookmark_border,
            color: isFavorite ? Colors.deepPurple : Colors.white,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => MovieInfoPage(docs: docs),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Поиск',
            fillColor: Colors.white10,
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white10),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('favourites')
            .stream(primaryKey: ['id'])
            .eq('id_user', userId),
        builder: (context, snapshotFav) {
          if (!snapshotFav.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          final favorites = snapshotFav.data!;
          final favoriteMovieIds = favorites
              .map((e) => int.parse(e['id_movie'].toString()))
              .toSet();

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('movie')
                .stream(primaryKey: ['id']),
            builder: (context, snapshotMovie) {
              if (!snapshotMovie.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                );
              }

              var movie = snapshotMovie.data!;

              if (searchController.text.isNotEmpty) {
                movie = movie
                    .where(
                      (element) => element['name'].toString().toLowerCase().contains(
                            searchController.text.toLowerCase(),
                          ),
                    )
                    .toList();
              }

              if (movie.isEmpty) {
                return const Center(
                  child: Text('Фильмы не найдены'),
                );
              }

              return ListView.builder(
                itemCount: movie.length,
                itemBuilder: (context, index) {
                  final docs = movie[index];
                  final isFavorite = favoriteMovieIds.contains(
                    int.parse(docs['id'].toString()),
                  );

                  return movieTile(context, docs, isFavorite);
                },
              );
            },
          );
        },
      ),
    );
  }
}