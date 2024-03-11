import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Home.dart';
import 'model/Usuario.dart';

class Cadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  void _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length > 6) {
          Usuario usuario = Usuario(nome: nome, email: email, senha: senha);
          _cadastrarUsuario(usuario);
        } else {
          _exibirMensagemErro("Preencha a senha! Digite mais de 6 caracteres");
        }
      } else {
        _exibirMensagemErro("Preencha o E-mail utilizando @");
      }
    } else {
      _exibirMensagemErro("Preencha o Nome");
    }
  }

  void _exibirMensagemErro(String mensagem) {
    setState(() {
      _mensagemErro = mensagem;
    });
  }

  Future<void> _cadastrarUsuario(Usuario usuario) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
      );

      // Salvar dados do usuário
      await FirebaseFirestore.instance.collection("usuarios").doc(userCredential.user!.uid).set(usuario.toMap());

      // Navegar para a tela principal
      Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
    } on FirebaseAuthException catch (e) {
      _exibirMensagemErro("Erro ao cadastrar usuário: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xff075E54)),
      padding: EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Image.asset(
                  "imagens/usuario.png",
                  width: 200,
                  height: 150,
                ),
              ),
              _campoTexto("Nome", _controllerNome),
              _campoTexto("E-mail", _controllerEmail, teclado: TextInputType.emailAddress),
              _campoTexto("Senha", _controllerSenha, senha: true),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                child: ElevatedButton(
                  child: Text("Cadastrar", style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: _validarCampos,
                ),
              ),
              Center(
                child: Text(
                  _mensagemErro,
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String hint, TextEditingController controller, {bool senha = false, TextInputType teclado = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        obscureText: senha,
        keyboardType: teclado,
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
