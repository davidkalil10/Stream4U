import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:stream4u/PlayMovie.dart';
import 'package:stream4u/components/play_btn.dart';
import 'package:stream4u/components/star_calculator.dart';
import 'package:stream4u/constants.dart';
import 'package:stream4u/models/movie.dart';

class MovieScreen extends StatefulWidget {
  final Movie filme;

  MovieScreen({required this.filme,});


  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late RiveAnimationController _btnAnimationController;
  late List<Map<String, dynamic>> _listaDeEpisodios;
  String _temporadaSelecionada = 'S01'; // Temporada padrão
  int intTemporadaSelecionada = 1;
  int _qntTemporadas =0;
  List<Map<String, dynamic>> _episodiosTemporadaSelecionada = [];
  bool _isMovie = false;
  String _movieURL = "";

  List<Map<String, dynamic>> extractUrls(String input) {
    List<Map<String, dynamic>> contents = [];
    List<String> tokens = input.split('#');
  //  print("teste");
   // print(tokens);
    String currentSeason = '';
    String currentEpisode = '';

    for (String token in tokens) {
      List<String> parts = token.split('\$');

      if (parts.length > 1) {
        String typeAndInfo = parts[0].trim();
        String data = parts[1].trim();

        String temporada = '';
        String episodio = '';

        RegExpMatch? match = RegExp(r'(S\d+)( E\d+)?').firstMatch(typeAndInfo);
        if (match != null) {
          temporada = match.group(1) ?? '';
          episodio = match.group(2) ?? '';
        }

        if (typeAndInfo.startsWith('S')) {
          // Série
          contents.add({'type': 'Série', 'season': temporada, 'episode': episodio, 'url': data});
        } else if (typeAndInfo.startsWith('E')) {
          // Episódio de Série
          contents.add({'type': 'Série', 'season': temporada, 'episode': episodio, 'url': data});
        } else if (typeAndInfo == 'HD') {
          // Filme
          contents.add({'type': 'Filme', 'season': 'Filme', 'episode': 'Filme', 'url': data});
          setState(() {
            _isMovie = true;
            _movieURL = contents.first["url"];
            print(_movieURL);
          });
        }
      }
    }

    return contents;
  }

  int _obterQntTemporadas(List<Map<String, dynamic>> listaDeEpisodios){
    Set<String> temporadasDisponiveis = Set<String>();
    for (Map<String, dynamic> episodio in listaDeEpisodios) {
      temporadasDisponiveis.add(episodio['season'].toString());
    }
    int quantidadeTemporadas = temporadasDisponiveis.length;
    return quantidadeTemporadas;
  }

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
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
    _btnAnimationController.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    _listaDeEpisodios = extractUrls(widget.filme.url);
    _qntTemporadas = _obterQntTemporadas (_listaDeEpisodios);
    print("vamos ver: " +_qntTemporadas.toString());
    print("aqui oh");
    print(_listaDeEpisodios);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: backgroundColor2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stream 4U",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Poppins",
                height: 1.2,
              ),
            ),
            Text(
              widget.filme.title,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                height: 1.2,
              ),
            ),
            SizedBox(width: 1,)
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Fecha a janela e retorna para a tela anterior
          },
        ),
      ),
      body: FutureBuilder(
        // Use FutureBuilder para carregar a imagem da URL
        future: precacheImage(NetworkImage(
            widget.filme.pictureURL),
            context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // A imagem foi carregada, exiba o conteúdo
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.filme.pictureURL), // Substitua pelo caminho real da sua imagem
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.05), // Ajuste a opacidade conforme necessário
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.filme.pictureURL,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                      child: Row(
                                        children: getStars(rating: double.parse(widget.filme.rating), starSize: 15),
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      )
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                'Dirigido por:',
                                                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                'Data de Lançamento:',
                                                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                'Duração:',
                                                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                'Gênero:',
                                                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                'Atores:',
                                                style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold), ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                widget.filme.director,
                                                style: TextStyle(fontSize: 17, color: Colors.white), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                widget.filme.date,
                                                style: TextStyle(fontSize: 17, color: Colors.white), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                '1h 49m',
                                                style: TextStyle(fontSize: 17, color: Colors.white), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                widget.filme.tags,
                                                style: TextStyle(fontSize: 17, color: Colors.white), ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.all(7),
                                              child: Text(
                                                widget.filme.actors,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 17, color: Colors.white), ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //SizedBox(width: 150,),
                                      PlayBtn(
                                        btnAnimationController: _btnAnimationController,
                                        press: () {
                                          _btnAnimationController.isActive = true;
                                          Future.delayed(Duration(milliseconds: 800), () {
                                          }
                                          );
                                          // print("botao clicado");
                                          if ( _isMovie)
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlayMovie(url: _movieURL,),
                                            ),
                                          );
                                        },
                                      ),
                                      DropdownButton(
                                        value: intTemporadaSelecionada,
                                        items: List.generate(
                                          // Substitua o número 3 pelo número total de temporadas disponíveis
                                          _qntTemporadas,
                                              (index) => DropdownMenuItem(
                                            value: index + 1, // Adiciona 1 para começar de 1 em vez de 0
                                            child: Text('Temporada S${index + 1}'),
                                          ),
                                        ),
                                        onChanged: (value) {
                                         // Navigator.pop(context); // Fecha o menu
                                          List<Map<String, dynamic>> episodiosTemporadaSelecionada = [];
                                          String temporadaSelecionada = value!<10?"S0"+value.toString():"S"+value.toString();

                                          for (Map<String, dynamic> episodio in _listaDeEpisodios) {
                                            if (episodio['season'] == temporadaSelecionada.toString()) {
                                              episodiosTemporadaSelecionada.add(episodio);
                                              print(episodio);
                                            }
                                          }
                                          setState(() {
                                            _temporadaSelecionada = temporadaSelecionada;
                                            print(_temporadaSelecionada);
                                            intTemporadaSelecionada = value!;
                                            _episodiosTemporadaSelecionada = episodiosTemporadaSelecionada;
                                          });
                                        },
                                      )
                                    //  SizedBox(width: 500,),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            widget.filme.subtitle,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: _listaDeEpisodios.length,
                            itemBuilder: (context, index){
                              Map<String, dynamic> episodio = _listaDeEpisodios[index];
                              //print("opa");
                             // print(episodio.toString());
                             // print(episodio['season']);
                              // Verificar se o episódio pertence à temporada selecionada
                              if (episodio['season'] == _temporadaSelecionada) {
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayMovie(url: episodio['url'],),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(episodio['episode']),
                                    subtitle: Text(episodio['url']),
                                    // Adicionar mais informações do episódio conforme necessário
                                  ),
                                );
                              } else {
                                return Container(); // Episódio não pertence à temporada selecionada
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 10, // Ajuste conforme necessário para a posição vertical
                      right: 20, // Ajuste conforme necessário para a posição horizontal
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 35,
                        ),
                      )
                    )

                  ],
                ),
              ),
            );
          } else {
          // Exiba um indicador de carregamento enquanto a imagem está sendo carregada
          return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

}
