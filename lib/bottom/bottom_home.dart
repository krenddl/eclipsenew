import 'package:easy_stars/easy_stars.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';
import 'package:eclipce_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomHomePage extends StatefulWidget {
  const BottomHomePage({super.key});

  @override
  State<BottomHomePage> createState() => _BottomHomePageState();
}

class _BottomHomePageState extends State<BottomHomePage> {
  final String user_id = Supabase.instance.client.auth.currentUser!.id;
  FavotireTable favotireTable = FavotireTable();

  Widget topPoster(BuildContext context, dynamic docs) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MovieInfoPage(docs: docs),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(right: 12),
        width: 120,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(docs['image']),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget categoryChip(String title, {bool selected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.deepPurple : Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget movieTile(BuildContext context, dynamic docs, bool isFavorite) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
          SizedBox(width: 12),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      EasyStarsRating(
                        initialRating: double.parse(docs['stars'].toString()),
                        filledColor: Colors.deepPurple,
                        emptyColor: Colors.white24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        docs['stars'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    docs['descriptiion'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              if (isFavorite) {
                await favotireTable.deleteFavourite(user_id, docs['id']);
              } else {
                await favotireTable.addFavourite(user_id, docs);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF120B1E),
      body: SafeArea(
        child: StreamBuilder(
          stream: Supabase.instance.client
              .from('favourites')
              .stream(primaryKey: ['id'])
              .eq('id_user', user_id),
          builder: (context, snapshotFav) {
            if (!snapshotFav.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              );
            }

            var favorites = snapshotFav.data;
            final favoriteIds = favorites!.map((e) => e['id_movie']).toSet();

            return StreamBuilder(
              stream: Supabase.instance.client
                  .from('movie')
                  .stream(primaryKey: ['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  );
                }

                var movie = snapshot.data!;

                if (movie.isEmpty) {
                  return Center(
                    child: Text(
                      'Фильмы не найдены',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),

                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movie.length > 3 ? 3 : movie.length,
                            itemBuilder: (context, index) {
                              return topPoster(context, movie[index]);
                            },
                          ),
                        ),

                        SizedBox(height: 16),

                        Center(
                          child: Container(
                            width: 130,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Color(0xFFE6D9F3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        MovieInfoPage(docs: movie[0]),
                                  ),
                                );
                              },
                              child: Text(
                                'Смотреть',
                                style: TextStyle(
                                  color: Color(0xFF2D1939),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        Text(
                          'Сейчас в топе',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),

                        SizedBox(height: 14),

                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              categoryChip('Комедии', selected: true),
                              categoryChip('Ужасы'),
                              categoryChip('Драма'),
                              categoryChip('Фэнтези'),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        ListView.builder(
                          itemCount: movie.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final docs = movie[index];
                            final isFavorite = favoriteIds.contains(docs['id']);

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
        ),
      ),
    );
  }
}