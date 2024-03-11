import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Home.dart';
import 'Login.dart';
import 'RouteGenerator.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData temaIOS = ThemeData(
    primaryColor: Colors.grey[200],
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25D366)),
  );

  final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff075E54),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25D366)),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Aplicativo',
      theme: _escolherTema(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _escolherTema() {
    if (kIsWeb) {
      return temaPadrao; // Usa tema padrão para a web
    } else {
      // Escolhe tema baseado na plataforma
      return Platform.isIOS ? temaIOS : temaPadrao;
    }
  }
}


