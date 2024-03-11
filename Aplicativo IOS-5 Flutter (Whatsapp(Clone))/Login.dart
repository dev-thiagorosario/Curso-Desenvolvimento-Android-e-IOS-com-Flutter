import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Cadastro.dart';
import 'Home.dart';
import 'RouteGenerator.dart';
import 'model/Usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  void _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        Usuario usuario = Usuario(email: email, senha: senha);
        _logarUsuario(usuario);
      } else {
        _exibirMensagemErro("Preencha a senha!");
      }
    } else {
      _exibirMensagemErro("Preencha o E-mail utilizando @");
    }
  }

  void _exibirMensagemErro(String mensagem) {
    setState(() {
      _mensagemErro = mensagem;
    });
  }

  Future<void> _logarUsuario(Usuario usuario) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
      );
      Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      _exibirMensagemErro("Erro ao autenticar usuário: ${e.message}");
    }
  }

  Future<void> _verificarUsuarioLogado() async {
    User? usuarioLogado = FirebaseAuth.instance.currentUser;
    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset("imagens/logo.png", width: 200, height: 150),
                ),
                _campoTexto("E-mail", _controllerEmail, TextInputType.emailAddress),
                _campoTexto("Senha", _controllerSenha, TextInputType.text, true),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    ),
                    onPressed: _validarCampos,
                  ),
                ),
                GestureDetector(
                  child: Text("Não tem conta? cadastre-se!", style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro())),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(_mensagemErro, style: TextStyle(color: Colors.red, fontSize: 20)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String hint, TextEditingController controller, TextInputType tipoTeclado, [bool senha = false]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        obscureText: senha,
        keyboardType: tipoTeclado,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
    );
  }
}
