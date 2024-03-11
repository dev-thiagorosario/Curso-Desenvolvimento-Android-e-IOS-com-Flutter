import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Configuracoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
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
  File? _imagem;
  String? _idUsuarioLogado;
  bool _subindoImagem = false;
  String? _urlImagemRecuperada;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  Future _recuperarImagem(String origemImagem) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: origemImagem == "camera" ? ImageSource.camera : ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _imagem = File(pickedFile.path);
        _subindoImagem = true;
        _uploadImagem();
      } else {
        print('Nenhuma imagem selecionada.');
      }
    });
  }

  Future _uploadImagem() async {
    if (_imagem == null || _idUsuarioLogado == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final arquivo = storageRef.child("perfil/$_idUsuarioLogado.jpg");

    try {
      await arquivo.putFile(_imagem!);
      final url = await arquivo.getDownloadURL();
      await _atualizarUrlImagemFirestore(url);

      setState(() {
        _urlImagemRecuperada = url;
        _subindoImagem = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _subindoImagem = false;
      });
    }
  }

  Future<void> _atualizarUrlImagemFirestore(String url) async {
    FirebaseFirestore.instance.collection("usuarios").doc(_idUsuarioLogado).update({
      "urlImagem": url,
    });
  }

  Future<void> _atualizarNomeFirestore() async {
    FirebaseFirestore.instance.collection("usuarios").doc(_idUsuarioLogado).update({
      "nome": _controllerNome.text,
    });
  }

  Future<void> _recuperarDadosUsuario() async {
    final auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      _idUsuarioLogado = usuarioLogado.uid;

      final snapshot = await FirebaseFirestore.instance.collection("usuarios").doc(_idUsuarioLogado).get();
      final dados = snapshot.data();
      setState(() {
        _controllerNome.text = dados?["nome"] ?? "";
        _urlImagemRecuperada = dados?["urlImagem"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (_subindoImagem) CircularProgressIndicator(),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage: _urlImagemRecuperada != null ? NetworkImage(_urlImagemRecuperada!) : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Câmera"),
                    onPressed: () => _recuperarImagem("camera"),
                  ),
                  FlatButton(
                    child: Text("Galeria"),
                    onPressed: () => _recuperarImagem("galeria"),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllerNome,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Nome",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 10),
                child: RaisedButton(
                  child: Text("Salvar", style: TextStyle(color: Colors.white, fontSize: 20)),
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  onPressed: _atualizarNomeFirestore,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
