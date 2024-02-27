import 'dart:math';
import 'package:flutter/material.dart';

class Jogo extends StatefulWidget {
  @override
  _JogoState createState() => _JogoState();
}

class _JogoState extends State<Jogo> {

  Image _imagemApp = Image.asset("images/padrao.png");
  var _mensagem = "Escolha uma opção Abaixo";
  String? _escolhaUsuario;


  void opcaoSelecionada(String escolhaUsuario) {
    var opcoes = ["Zero", "Um", "Dois", "Três", "Quatro", "Cinco"];
    var numero = Random().nextInt(6);
    var escolhaApp = opcoes[numero];

    switch(escolhaApp){
      case "Zero":
        setState(() {
          this._imagemApp = Image.asset("images/Zero.png");
        });
        break;
      case "Um":
        setState(() {
          this._imagemApp = Image.asset("images/Um.png");
        });
        break;
      case "Dois":
        setState(() {
          this._imagemApp = Image.asset("images/Dois.png");
        });
        break;
      case "Três":
        setState(() {
          this._imagemApp = Image.asset("images/Tres.png");
        });
        break;
      case "Quatro":
        setState(() {
          this._imagemApp = Image.asset("images/Quatro.png");
        });
        break;
      case "Cinco":
        setState(() {
          this._imagemApp = Image.asset("images/Cinco.png");
        });
        break;
    }

    //Validação Do ganhador
    var soma = numero + int.parse(escolhaUsuario);
    var resultado = soma % 2 == 0 ? "Par" : "Ímpar";
    verificarVencedor(resultado);
  }

  void verificarVencedor(String resultado) {
    if (_escolhaUsuario != null &&
        ((_escolhaUsuario == "Par" && resultado == "Par") ||
            (_escolhaUsuario == "Ímpar" && resultado == "Ímpar"))) {
      setState(() {
        _mensagem = "Você venceu!";
      });
    } else {
      setState(() {
        _mensagem = "Você perdeu!";
      });
    }
  }

  void _definirEscolhaUsuario(String escolha) {
    setState(() {
      _escolhaUsuario = escolha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Par ou Impar"),
      ),
      body: SingleChildScrollView( // Adiciona a capacidade de rolagem
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                "Escolha do App",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _imagemApp,
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                this._mensagem,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap:  () => opcaoSelecionada("0"),
                  child: Image.asset("images/Zero.png"),
                ),
                GestureDetector(
                  onTap:  () => opcaoSelecionada("1"),
                  child: Image.asset("images/Um.png"),
                ),
                GestureDetector(
                  onTap:  () => opcaoSelecionada("2"),
                  child: Image.asset("images/Dois.png"),
                ),
                GestureDetector(
                  onTap:  () => opcaoSelecionada("3"),
                  child: Image.asset("images/Tres.png"),
                ),
                GestureDetector(
                  onTap:  () => opcaoSelecionada("4"),
                  child: Image.asset("images/Quatro.png"),
                ),
                GestureDetector(
                  onTap:  () => opcaoSelecionada("5"),
                  child: Image.asset("images/Cinco.png"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _definirEscolhaUsuario("Par"),
                  child: Text("Par"),
                ),
                ElevatedButton(
                  onPressed: () => _definirEscolhaUsuario("Ímpar"),
                  child: Text("Ímpar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
