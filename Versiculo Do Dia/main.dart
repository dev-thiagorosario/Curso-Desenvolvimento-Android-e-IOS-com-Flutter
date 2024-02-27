import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<int, String> _frases = {
    1: "As misericórdias do Senhor são a causa de não sermos consumidos, por que as suas misericórdias não têm fim; renovam-se cada manhã. Grande é a tua fidelidade. - Lamentações 3:22-23",
    2: "Acorde, ó minha alma! Acordem, lira e harpa! Quero acordar o alvorecer. - Salmos 57:8",
    3: "Lancem sobre ele todas as suas ansiedades, porque ele cuida de vocês. - 1 Pedro 5:7",
    4: "Entre vocês há alguém que está doente? Que ele mande chamar os presbíteros da igreja, para que estes orem sobre ele e o unjam com óleo, em nome do Senhor. A oração feita com fé curará o doente; o Senhor o levantará. E, se houver cometido pecados, ele será perdoado. - Tiago 5:14-15"
  };

  var _fraseGerada = "Clique Abaixo para gerar uma frase";

  void _gerarFrase() {
    int fraseId = Random().nextInt(_frases.length) + 1;
    setState(() {
      _fraseGerada = _frases[fraseId]!;
    });
  }

  void _mostrarVersiculo() {
    int fraseId = Random().nextInt(_frases.length) + 1;
    String versiculo = _frases[fraseId]!;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FrasePage(versiculo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Versículos Do Dia"),
        backgroundColor: Colors.pink[900],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.amber),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/biblia.png"),
            Text(
              _fraseGerada,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              child: Text(
                "Versiculo Do Dia",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: _mostrarVersiculo,
            ),
          ],
        ),
      ),
    );
  }
}

class FrasePage extends StatelessWidget {
  final String frase;
  FrasePage(this.frase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versículo Selecionado'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            frase,
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
