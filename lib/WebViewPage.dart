import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {


  const WebViewPage({Key? key}) : super(key: key);


  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  //final String url = 'https://cineliso.tv/';
  late String _url;
  late var _controller = WebViewController();


  // final _controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // print the loading progress to the console
  //         // you can use this value to show a progress bar if you want
  //         debugPrint("Loading: $progress%");
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse(_url));

  _inicializarController(){

   setState(() {
     _controller  = WebViewController()
       ..setJavaScriptMode(JavaScriptMode.unrestricted)
       ..setNavigationDelegate(
         NavigationDelegate(
           onProgress: (int progress) {
             // print the loading progress to the console
             // you can use this value to show a progress bar if you want
             debugPrint("Loading: $progress%");
           },
           onPageStarted: (String url) {},
           onPageFinished: (String url) {},
           onWebResourceError: (WebResourceError error) {},
           onNavigationRequest: (NavigationRequest request) {
             return NavigationDecision.navigate;
           },
         ),
       )
       ..loadRequest(Uri.parse(_url));
   });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  //  String url = 'https://www.cineliso.com/player/?url=https://s2.tmdb.bet/20231104/45vCFDVg/index.m3u8';
    String url = 'https://cineliso.tv/';
    setState(() {
      _url = url;
    });

    _inicializarController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
