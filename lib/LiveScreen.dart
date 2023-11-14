import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_rtmp_ext/models/android_play_manager.dart';
import 'package:video_player_rtmp_ext/widget/video_player_rtmp_ext.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player_rtmp_ext/video_player_rtmp_ext.dart';
import 'package:chewie/chewie.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {

  late String _url;
  bool _tocando = false;

  late IJKPlayerController controller;
  late VideoPlayerController videoPlayerController;
  late ChewieController _chewieController;


  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> _inicializarController () async {

    await videoPlayerController.initialize();
    ChewieController chewieController =  ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
      isLive: true
    );

    setState(() {
      _chewieController = chewieController;
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
    videoPlayerController.dispose();
    _chewieController.dispose();
    controller.stop();
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
    setState(() {
      _url = url;
    });

    controller = IJKPlayerController.network(_url);
    videoPlayerController = VideoPlayerController.network(
        _url);

    _tocando = true;

    _inicializarController();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("live broadcase")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("testando"),
            SizedBox(height: 20,),
            // GestureDetector(
            //   onTap: () async {
            //     print("passei aqui");
            //     if (await controller.isPlaying){
            //       await controller.pause();
            //     } else {
            //       await controller.play();
            //     }
            //   },
            //   onLongPress: (){
            //     print("tenteiiii");
            //   },
            //   child: AspectRatio(
            //     //  aspectRatio: 1920/1080,
            //     aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
            //     child: VideoPlayerRtmpExtWidget(
            //       controller: controller,
            //       viewCreated: (IJKPlayerController _) async {
            //         if(controller.isAndroid){
            //           await controller.setPlayManager(PlayerFactory.exo2PlayerManager);
            //         }
            //
            //         await controller.play();
            //       },
            //     ),
            //   ),
            // ),
        ElevatedButton(
          onPressed: () async {
            print("tenteiiii");
            if (await _tocando){
              print("to tocando");
             await  controller.pause();
              setState(() {
                _tocando = false;
              });

            } else {
              print("to pausado");
              await  controller.play();
              setState(() {
                _tocando = true;
              });
            }

          },
          child: Text('Click me'),
        ),
            Chewie(controller: _chewieController)
          ],
        ),
      ),
    );

    // Scaffold(
    //   body: WebViewWidget(controller: _controller),
    // );
  }
}
