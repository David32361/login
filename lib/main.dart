// lib/main.dart
import 'package:flutter/material.dart';
import 'paginas/login.dart';
import 'paginas/registro.dart';
import 'paginas/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(name: 'Usuario'),
      },
    );
  }
}
