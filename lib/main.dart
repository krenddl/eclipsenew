import 'package:eclipce_app/bottom/recovery_password.dart';
import 'package:eclipce_app/check.dart';
import 'package:eclipce_app/home.dart';
import 'package:flutter/material.dart';
import 'package:eclipce_app/loading.dart';
import 'package:eclipce_app/auth.dart';
import 'package:eclipce_app/reg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndhcG9mdW9ueGhzZ2tuY2N4cWJpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5ODA1NzQsImV4cCI6MjA4NjU1NjU3NH0.w9Ncq3hq8AaUcVy5hFemZBKIsMo199Pb4FZlnaT6CqI',
    url: 'https://wapofuonxhsgknccxqbi.supabase.co',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
        '/auth': (context) => AuthPage(),
        '/reg': (context) => RegPage(),
        '/home': (context) => HomePage(),
        '/check': (context) => CheckPage(),
        '/recpass': (context) => RecoveryPasswordPage(),
      },
    );
  }
}
