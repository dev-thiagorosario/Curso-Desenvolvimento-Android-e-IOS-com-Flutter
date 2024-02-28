import 'package:flutter/material.dart';
import 'package:youtube/Api.dart';
import 'package:youtube/model/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Inicio extends StatefulWidget {
  final String pesquisa;

  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  Future<List<Video>>? _futureVideos;

  @override
  void initState() {
    super.initState();
    _futureVideos = Api().pesquisar(widget.pesquisa);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: _futureVideos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<Video>? videos = snapshot.data;

          return ListView.separated(
            itemBuilder: (context, index) {
              Video video = videos![index];

              return GestureDetector(
                onTap: () {
                  _playYoutubeVideo(video.id);
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(video.imagem),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(video.titulo),
                      subtitle: Text(video.canal),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(height: 2, color: Colors.grey),
            itemCount: videos!.length,
          );
        } else {
          return Center(child: Text("Nenhum dado a ser exibido!"));
        }
      },
    );
  }

  void _playYoutubeVideo(String videoId) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(),
        body: player,
      ),
    )));
  }
}
