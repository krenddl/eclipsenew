import 'package:eclipce_app/database/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final Supabase _supabase = Supabase.instance;

  Future<({LocalUser? user, String? error})> signIn(
    String email,
    String password,
  ) async {
    try {
      final authResponse = await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        return (
          user: null,
          error: 'Пользователь не найден или сессия не создана',
        );
      }
      return (user: LocalUser.fromSupabase(user), error: null);
    } on AuthException catch (e) {
      return (user: null, error: e.message);
    } catch (e) {
      return (user: null, error: 'Неизвестная ошибка: $e');
    }
  }

  Future<LocalUser?> signUp(String email, String password) async {
    try {
      AuthResponse authResponse = await _supabase.client.auth.signUp(
        email: email,
        password: password,
      );

      User user = authResponse.user!;

      return LocalUser.fromSupabase(user);
    } catch (e) {
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      return;
    }
  }

  Future recoveryPassword(String email) async {
    try {
      await _supabase.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      return null;
    }
  }
}
