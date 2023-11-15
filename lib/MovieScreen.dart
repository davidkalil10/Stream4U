import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:shared_preferences/shared_preferences.dart';
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
  late rive.RiveAnimationController _btnAnimationController;
  late List<Map<String, dynamic>> _listaDeEpisodios;
  String _temporadaSelecionada = 'S01'; // Temporada padrão
  int intTemporadaSelecionada = 1;
  int _qntTemporadas =0;
  List<Map<String, dynamic>> _episodiosTemporadaSelecionada = [];
  bool _isMovie = false;
  String _movieURL = "";
  List<String> _favoriteIds = [];

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

  Future<void> _saveFavorite(String movieId, bool isFavorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupere a lista de favoritos existente
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    // Adicione ou remova o ID do filme dependendo do status de favorito
    if (isFavorite) {
      favorites.add(movieId);
    } else {
      favorites.remove(movieId);
    }

    // Salve a lista atualizada
    prefs.setStringList('favorites', favorites);
  }

  Future<List<String>> _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _favoriteIds = prefs.getStringList('favorites') ?? [];
    });
    return
      prefs.getStringList('favorites') ?? [];
  }

  Future<void> _favoriteCheck() async {
    List<String> favoriteIds = await _getFavorites();
    print(favoriteIds);
    print("oque deu:");
    if(favoriteIds.contains(widget.filme.id.toString())){
      setState(() {
        widget.filme.isFavorite = true;
      });
    }
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
    _btnAnimationController = rive.OneShotAnimation("active", autoplay: false);
    _listaDeEpisodios = extractUrls(widget.filme.url);
    _qntTemporadas = _obterQntTemporadas (_listaDeEpisodios);
    print("vamos ver: " +_qntTemporadas.toString());
    print("aqui oh");
    print(_listaDeEpisodios);
    _getFavorites();
    _favoriteCheck();

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
                                            if ( _isMovie == true)
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
                                            ),
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
                                            if ( _isMovie == true)
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //SizedBox(width: 150,),
                                      Container(
                                        //margin: EdgeInsets.all(0),
                                        //padding: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Colors.red, Colors.orange],
                                          ),
                                        ),
                                        child: ElevatedButton.icon(
                                          clipBehavior: Clip.none,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            disabledBackgroundColor: Colors.transparent,
                                            disabledForegroundColor: Colors.transparent,
                                            backgroundColor: Colors.transparent, // Define a cor de fundo como transparente
                                          ),
                                          onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PlayMovie(url: _movieURL),
                                                ),
                                              );
                                          },
                                          icon: Icon(Icons.play_arrow, color: Colors.white),
                                          label: Text( _isMovie == true ? 'Play': 'Play '+_temporadaSelecionada+" E01",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if ( _isMovie == false)
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Colors.grey.shade300, Colors.grey.shade400]
                                            ),
                                          ),
                                          child: DropdownButton(
                                            value: intTemporadaSelecionada,
                                            iconEnabledColor: Colors.white,
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 200,),
                                      SizedBox(width: 1),
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        if ( _isMovie == false)
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width*0.95,
                          child: ListView.builder(
                            itemCount: _listaDeEpisodios.length,
                            itemBuilder: (context, index){
                              Map<String, dynamic> episodio = _listaDeEpisodios[index];
                              //print("opa");
                             // print(episodio.toString());
                             // print(episodio['season']);
                              // Verificar se o episódio pertence à temporada selecionada
                              if (episodio['season'] == _temporadaSelecionada && episodio['episode'] == " E01"){
                                print("passei aqui");
                                _movieURL = episodio['url'];
                              }
                              if (episodio['season'] == _temporadaSelecionada) {
                                if(episodio['episode'] == "E01"){
                                  print("passei aqui");
                                }
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayMovie(url: episodio['url'],),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.all(8),
                                    child: ListTile(
                                      selectedColor: Colors.orange,
                                      leading: Container(
                                        width: 90,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(widget.filme.pictureURL),
                                            fit: BoxFit.cover
                                          )
                                        ),
                                      ),
                                      title: Text(_temporadaSelecionada + episodio['episode']),
                                      //subtitle: Text(episodio['url']),
                                      // Adicionar mais informações do episódio conforme necessário
                                    ),
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
                        onPressed: () {
                          setState(() {
                            widget.filme.isFavorite = !widget.filme.isFavorite;
                          });
                          // Salve ou remova o ID do filme nos favoritos (use SharedPreferences)
                          _saveFavorite(widget.filme.id.toString(), widget.filme.isFavorite);
                        },
                        icon: Icon(
                          widget.filme.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
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
