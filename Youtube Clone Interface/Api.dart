import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youtube/model/Video.dart';

const CHAVE_YOUTUBE_API = "AIzaSyA0PPK3gmOSw09MZBL2eLnKPF7C15HeZNw";
const ID_CANAL = "UCVHFbqXqoYvEWM1Ddxl0QDg";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class Api {
  Future<List<Video>> pesquisar(String pesquisa) async {
    var url = Uri.parse(URL_BASE + "search"
        "?part=snippet"
        "&type=video"
        "&maxResults=20"
        "&order=date"
        "&key=$CHAVE_YOUTUBE_API"
        "&channelId=$ID_CANAL"
        "&q=$pesquisa");

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var dadosJson = json.decode(response.body);
        
        List<Video> videos = dadosJson["items"].map<Video>(
            (map) {
              return Video.fromJson(map);
            }
        ).toList();

        return videos;
      } else {
        // Tratamento de outros códigos de status
        throw Exception('Falha ao carregar dados');
      }
    } catch (e) {
      // Tratamento de erros de rede ou de parsing
      throw Exception('Erro ao fazer a requisição: $e');
    }
  }
}


