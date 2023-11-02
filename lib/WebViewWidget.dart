import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:stream4u/WebViewPage.dart';
import 'package:stream4u/WebViewForWeb.dart';
import 'package:stream4u/WebViewForWeb2.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final WebViewController? controller;

  WebViewWidget({this.controller});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebViewForWeb2();
    } else {
      return WebViewPage();
    }
  }
}
