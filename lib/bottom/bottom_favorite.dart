import 'package:easy_stars/easy_stars.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';
import 'package:eclipce_app/database/favourites/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomFavoritePage extends StatefulWidget {
  const BottomFavoritePage({super.key});

  @override
  State<BottomFavoritePage> createState() => _BottomFavoritePageState();
}

class _BottomFavoritePageState extends State<BottomFavoritePage> {
  final String user_id = Supabase.instance.client.auth.currentUser!.id;
  FavotireTable favotireTable = FavotireTable();

  Widget movieTile(BuildContext context, dynamic docs) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(docs['name'], maxLines: 3),
          EasyStarsRating(
            initialRating: double.parse(docs['stars'].toString()),
            filledColor: Colors.deepPurple,
          ),
        ],
      ),
      subtitle: Text(
        docs['descriptiion'],
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Image.network(
        docs['image'],
        width: 50,
        height: 70,
        fit: BoxFit.cover,
      ),
      trailing: IconButton(
        onPressed: () async {
          await favotireTable.deleteFavourite(user_id, docs['id']);
          setState(() {
          });
        },
        icon: Icon(
          Icons.bookmark,
          color: Colors.deepPurple,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MovieInfoPage(docs: docs),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: StreamBuilder(
        stream: Supabase.instance.client
            .from('favourites')
            .stream(primaryKey: ['id'])
            .eq('id_user', user_id),
        builder: (context, snaphotFav) {
          if (!snaphotFav.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          }

          var favorites = snaphotFav.data;

          if (favorites == null || favorites.isEmpty) {
            return Center(
              child: Text('Избранное пусто'),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, indexFav) {
              return FutureBuilder(
                future: Supabase.instance.client
                    .from('movie')
                    .select()
                    .eq('id', favorites[indexFav]['id_movie']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  }

                  var movie = snapshot.data;

                  if (movie == null || movie.isEmpty) {
                    return SizedBox();
                  }

                  return movieTile(context, movie[0]);
                },
              );
            },
          );
        },
      ),
    );
  }
}