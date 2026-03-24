import 'package:supabase_flutter/supabase_flutter.dart';

class UserTable {
  final Supabase supabase = Supabase.instance;

  Future<void> addUserTable(
    String email,
    String fullname,
    String password,
    String date,
    String gender,
    String avatar,
  ) async {
    try {
      await supabase.client.from('users').insert({
        'email': email,
        'fullname': fullname,
        'password': password,
        'gender': gender,
        'dateofbirth': date,
        'avatar': "",
      });

      print("ПОЛЬЗОВАТЕЛЬ ДОБАВЛЕН!");
    } catch (e) {
      return;
    }
  }

  Future<void> updateImage(String url, String id_user) async {
    try {
      await supabase.client
          .from('users')
          .update({'avatar': url})
          .eq('id', id_user);
    } catch (e) {
      return;
    }
  }

  Future<void> updateFullname(String name, String user_id) async {
    try {
      await supabase.client
          .from('users')
          .update({'fullname': name})
          .eq('id', user_id);
    } catch (e) {
      return;
    }
  }
}
