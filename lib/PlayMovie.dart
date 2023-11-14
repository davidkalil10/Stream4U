import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';


class PlayMovie extends StatefulWidget {
  final String url;
 // final String url2 = "http://g8kf.co:8880/movie/Davidk/1u9cr3yk/36606.mp4";

  PlayMovie({required this.url,});

  @override
  State<PlayMovie> createState() => _PlayMovieState();
}

class _PlayMovieState extends State<PlayMovie> {

  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Quando o State é descartado, volta para as orientações preferidas do sistema
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.portraitUp,
      //DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: YoYoPlayer(
          //url ( .m3u8 video streaming link )
          //example ( url :"https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8" )
          //example ( url :"https://player.vimeo.com/external/440218055.m3u8?s=7ec886b4db9c3a52e0e7f5f917ba7287685ef67f&oauth2_token_id=1360367101" )
          //   url:  "https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
          // url:  "https://s1.tmdb.bet/20230916/gdTmCERj/index.m3u8",
          url:  widget.url,
          videoStyle: VideoStyle(
            playIcon : Icon(Icons.play_arrow, color: Colors.white,size: 50,),
            pauseIcon : Icon(Icons.pause, color: Colors.white,size: 50,),
           // showLiveDirectButton: true,
            fullscreenIcon : Icon(Icons.fullscreen,size: 1,),
            forwardIcon : Icon(Icons.skip_next, color: Colors.white,),
            backwardIcon : Icon(Icons.skip_previous, color: Colors.white,),
          ),
          videoLoadingStyle: VideoLoadingStyle(loading : Center(child: Text("Loading video"))),
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          allowCacheFile: true,
          onFullScreen: (value){
           if (value == false) Navigator.of(context).pop();
          },

        ),
      ),
    );
  }
}
