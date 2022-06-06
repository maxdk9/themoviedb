import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  final String youtubeKey;
  const MovieTrailerWidget({Key? key,required this.youtubeKey}) : super(key: key);

  @override
  _MovieTrailerWidgetState createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  late YoutubePlayerController _controller;


  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeKey,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,

        enableCaption: true,
      ),
    );
      //..addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ), builder: (context , player ) {
      return
          Scaffold(
            appBar: AppBar(title: Text('Trailer'),),
            body: Center(
              child: player,
            ),
          );
    },
    );
  }
}
