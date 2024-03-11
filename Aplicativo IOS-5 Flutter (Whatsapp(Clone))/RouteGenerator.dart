import 'package:flutter/material.dart';
import 'Cadastro.dart';
import 'Configuracoes.dart';
import 'Home.dart';
import 'Login.dart';
import 'Mensagens.dart';
import 'model/Usuario.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/configuracoes":
        return MaterialPageRoute(builder: (_) => Configuracoes());
      case "/mensagens":
        // Verificação de tipo para argumentos
        if (settings.arguments is Usuario) {
          Usuario usuarioContato = settings.arguments as Usuario;
          return MaterialPageRoute(builder: (_) => Mensagens(usuarioContato));
        }
        // Se os argumentos não forem do tipo esperado, redirecione para uma rota de erro.
        return _erroRota();
      default:
        return _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text("Tela não encontrada")),
          body: Center(child: Text("Tela não encontrada")),
        );
      }
    );
  }
}
