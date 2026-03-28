import 'package:easy_stars/easy_stars.dart';
import 'package:eclipce_app/database/favourites/favourite.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:eclipce_app/bottom/search/movie_info.dart';

class BottomSearchPage extends StatefulWidget {
  const BottomSearchPage({super.key});

  @override
  State<BottomSearchPage> createState() => _BottomSearchPageState();
}

class _BottomSearchPageState extends State<BottomSearchPage> {
  TextEditingController searchController = TextEditingController();
  FavotireTable favotireTable = FavotireTable();
  final String user_id = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  Widget movieTile(BuildContext context, dynamic docs, bool isFavorite) {
    return ListTile(
      tileColor: Colors.transparent,

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
          if (isFavorite) {
            await favotireTable.deleteFavourite(user_id, docs['id']);
          } else {
            await favotireTable.addFavourite(user_id, docs);
          }
          

          setState(() {
            
          });
        },
        icon: Icon(
          isFavorite ? Icons.bookmark : Icons.bookmark_border,
          color: isFavorite ? Colors.deepPurple : Colors.white,
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
      backgroundColor: Color(0xFF121212), 

      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Поиск',
            fillColor: Colors.white10,
            prefixIcon: Icon(
              (Icons.search),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white10),
            ),
          ),
        ),
      ),

      body: StreamBuilder(
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

          final favoriteIds = favorites!
              .map((e) => e['id_movie'])
              .toSet();

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

              var movie = snapshot.data;

              if (searchController.text.isNotEmpty) {
                movie = movie!
                    .where(
                      (element) => element['name']
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()),
                    )
                    .toList();
              }

              return ListView.builder(
                itemCount: movie!.length,
                itemBuilder: (context, index) {
                  final docs = movie?[index];
                  final isFavorite =
                      favoriteIds.contains(docs?['id']);

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