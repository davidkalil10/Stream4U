import 'dart:html' as html;
import 'package:flutter/material.dart';

class WebViewForWeb extends StatefulWidget {
  @override
  _WebViewForWebState createState() => _WebViewForWebState();
}

class _WebViewForWebState extends State<WebViewForWeb> {
  final String url = 'https://cineliso.tv/';

  @override
  void initState() {
    super.initState();
    // Carrega a URL da web no início da criação do widget
    loadWebPage();
  }

  void loadWebPage() {
    final iframe = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100vh' // Define altura para ocupar toda a tela
      ..setAttribute('sandbox', 'allow-same-origin allow-scripts allow-popups allow-forms allow-pointer-lock allow-top-navigation');

    // Obtém uma referência para o corpo da página HTML
    html.Element? body = html.document.body;

    // Adiciona o IFrame ao corpo da página
    body!.append(iframe);

    // Aplica estilos CSS para o body e o HTML para ocupar toda a tela
    html.document.documentElement!.style.height = '100%';
    body.style.height = '100%';
    body.style.margin = '0'; // Remove margens
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Não é necessário ter um Container aqui
  }
}
