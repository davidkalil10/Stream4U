import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream4u/models/channel.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_rtmp_ext/models/android_play_manager.dart';
import 'package:video_player_rtmp_ext/widget/video_player_rtmp_ext.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player_rtmp_ext/video_player_rtmp_ext.dart';
import 'package:chewie/chewie.dart';

class LiveScreen extends StatefulWidget {
  final String channelURL;
  const LiveScreen({Key? key, required this.channelURL}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {

  late String _url;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;


  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> _inicializarController () async {

    await _videoPlayerController.initialize();
    ChewieController chewieController;
    chewieController =  ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        fullScreenByDefault: true,
        isLive: true,
        aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
        controlsSafeAreaMinimum: EdgeInsets.only(top: 5,bottom: 5)
    );
     setState(() {
       _chewieController =  chewieController;
     });


  }


  @override
  void dispose() {
    // Quando o State é descartado, volta para as orientações preferidas do sistema
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();


   //   String url = 'https://www.cineliso.com/player/?url=https://s2.tmdb.bet/20231104/45vCFDVg/index.m3u8';
    String url = "http://iptv.cineliso.com:80/cinelisotv/baximovi/66966"; // funciona melhor
   // String url = "http://iptv.cineliso.com:80/cinelisotv/baximovi/67219"; // funciona melhor
  //  String url = "https://s2.tmdb.bet/20231104/45vCFDVg/index.m3u8"; // tb funciona
  //  String url = "http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8";
  //  String url = "http://iptv.cineliso.com/live/cinelisotv/baximovi/67219.m3u8"; //funciona
    //String url = 'https://cineliso.tv/';
   //  String url = "http://g8kf.co:8880/Davidk/1u9cr3yk/11127";
   //  setState(() {
   //    _url = widget.channelURL;
   //  });

    _videoPlayerController = VideoPlayerController.network(
        widget.channelURL);


    _inicializarController();

     _chewieController =  ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        fullScreenByDefault: true,
        isLive: true,
        aspectRatio: 1920/1080,
        controlsSafeAreaMinimum: EdgeInsets.only(top: 5,bottom: 5)
    );


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("live broadcase")),
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
