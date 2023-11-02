import 'package:flutter/material.dart';
//import 'dart:html' as html;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';


class WebViewForWeb2 extends StatefulWidget {

  @override
  _WebViewForWeb2State createState() => _WebViewForWeb2State();
}

class _WebViewForWeb2State extends State<WebViewForWeb2> {

  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
    LoadRequestParams(
      uri: Uri.parse('https://cineliso.tv/'),
    ),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
    );
  }
}
