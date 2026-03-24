import 'package:supabase_flutter/supabase_flutter.dart';

class FavotireTable {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> addFavourite(String userId, dynamic docs) async {
    final movieId = int.parse(docs['id'].toString());

    final existing = await supabase
        .from('favourites')
        .select()
        .eq('id_user', userId)
        .eq('id_movie', movieId)
        .maybeSingle();

    if (existing != null) return;

    await supabase.from('favourites').insert({
      'id_user': userId,
      'id_movie': movieId,
    });
  }

  Future<void> deleteFavourite(String userId, int movieId) async {
    await supabase
        .from('favourites')
        .delete()
        .eq('id_user', userId)
        .eq('id_movie', movieId);
  }

  Future<bool> isFavourite(String userId, int movieId) async {
    final data = await supabase
        .from('favourites')
        .select()
        .eq('id_user', userId)
        .eq('id_movie', movieId)
        .maybeSingle();

    return data != null;
  }

  Future<void> toggleFavourite(String userId, dynamic docs) async {
    final movieId = int.parse(docs['id'].toString());
    final exists = await isFavourite(userId, movieId);

    if (exists) {
      await deleteFavourite(userId, movieId);
    } else {
      await addFavourite(userId, docs);
    }
  }
}