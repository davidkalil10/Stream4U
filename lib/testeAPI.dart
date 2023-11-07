import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stream4u/components/movie_card.dart';
import 'package:stream4u/components/star_calculator.dart';
import 'package:stream4u/constants.dart';
import 'package:stream4u/models/movie.dart';

class testeAPI extends StatefulWidget {
  const testeAPI({Key? key}) : super(key: key);

  @override
  State<testeAPI> createState() => _testeAPIState();
}

class _testeAPIState extends State<testeAPI> {

  List<Map<String, dynamic>> _movieCategories = [];
  List<Map<String, dynamic>> _seriesCategories = [];
  List<Map<String, dynamic>> _animationCategories = [];
  List<dynamic> _contentList = [];
  List<dynamic> _contentListFiltered = [];
  bool isVisible = true;
  bool isSubtitleOn = false;
  bool _allowContent = false;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCategories = [];


  String _urlfilme = "https://www.cineliso.com/upload/vod/20231013-15/96e3fdae46f12bda1b4a7126ef0f258b.jpg";
  late Movie _filme;
  late List<Movie> _listaFilmes;

  void fetchAPI() async {
  //  var apiUrl = 'https://api.cinelisoapi.com/api.php/provide/vod/';
   // var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/?ac=videolist&ids=4438"; //serie
 //  var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/?ac=videolist&ids=2618"; //filme
 //  var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/?ac=videolist&ids=2618"; //consulta unitaria
   var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo
  // var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/?t=12"; //pesquisa por TIPE ID especifico que é o ID da categoria
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Se a solicitação for bem-sucedida, analise os dados JSON
      var data = response.body;
      // Faça algo com os dados aqui
     // print(data);
      Map<String, dynamic> dataMap = json.decode(data);

      //Obtem o total de conteúdos disponiveis
      int totalContents = dataMap['total'];
      print('Total de conteúdos disponíveis: $totalContents');
      int pageCount = int.parse(dataMap['pagecount'].toString());
      print('Total de paginas disponíveis: $pageCount');

      List<dynamic> allContent = [];
      // Itera sobre todas as páginas para obter o conteúdo
      for (int page = 1; page <= pageCount; page++) {
        final pageUrl = apiUrl + '?pg=$page';
        final pageResponse = await http.get(Uri.parse(pageUrl));
        final Map<String, dynamic> pageData = json.decode(pageResponse.body);
        final List<dynamic> content = pageData['list'];

        allContent.addAll(content);
      }

      // Converte o conteúdo combinado de todas as páginas em JSON
      final combinedContentJson = json.encode(allContent);

      List<dynamic> contentList = json.decode(combinedContentJson);

      print("Total de conteudos" + contentList.length.toString());

      // Iterando pelos elementos da lista e imprimindo
      for (var content in contentList) {
        print(content);

      }

      print("TermineiCaraio");

      setState(() {
        _contentList = contentList;
        _contentListFiltered = contentList;
      });

      // Imprime o JSON combinado
    //  print(combinedContentJson);


      // //---------------------------------------------------------------------------
      //
      // //Separar as categorias
      // //type_id = ID da Categoria
      // //type_pid = ID da Categoria Macro
      // //type_name = nome da categoria
      //
      // List<Map<String, dynamic>> movieCategories = [];
      // List<Map<String, dynamic>> seriesCategories = [];
      // List<Map<String, dynamic>> animationCategories = [];
      //
      // List<dynamic> categories = dataMap['class'];
      // for (var category in categories) {
      //   if (category['type_pid'] == 1) {
      //     movieCategories.add(category);
      //     } else if (category['type_pid'] == 2) {
      //       seriesCategories.add(category);
      //     } else if (category['type_pid'] == 3) {
      //       animationCategories.add(category);
      //     }
      //   }
      //
      // print('Categorias de Filmes:');
      // print(movieCategories);
      //
      // print('Categorias de Séries:');
      // print(seriesCategories);
      //
      // print('Categorias de Animação:');
      // print(animationCategories);
      //
      //
      // // Obtém o primeiro item da lista
      // Map<String, dynamic> firstItem = dataMap['list'][0];
      //
      // // Itera sobre os atributos e imprime
      // firstItem.forEach((key, value) {
      //   print('$key: $value');
      //
      // });
      //
      // Map<String, dynamic> detalheConteudo = json.decode(data);
      // List<dynamic> dataList = detalheConteudo['list'];
      //
      // for (var item in dataList) {
      //   if (item.containsKey('vod_play_url')) {
      //     List<String> playURLs = item['vod_play_url'].split('#');
      //
      //     int totalEpisodios = playURLs.length;
      //     print("Total Episodios:" +totalEpisodios.toString());
      //
      //     for (var url in playURLs) {
      //       List<String> parts = url.split(r'$');
      //         String episodeDescription = parts[0];
      //         String contentType = totalEpisodios == 1? "Filme": "Serie";
      //         String contentURL = parts[1];
      //
      //         print('Tipo: $contentType');
      //         print('Episodio: $episodeDescription');
      //         print('URL: $contentURL');
      //       }
      //     }
      //   }
      //
      // //---------------------------------------------------------------------------

    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }
  }

  void consultaUnitariaAPI(String idConteudo) async{

    var apiBASE = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo
    var apiUrl = apiBASE + "?ac=videolist&ids=" +idConteudo; //tudo
    print(apiUrl);
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Se a solicitação for bem-sucedida, analise os dados JSON
      var data = response.body;
      // Faça algo com os dados aqui

      Map<String, dynamic> dataMap = json.decode(data);

      //Obtem o total de conteúdos disponiveis
      int totalContents = dataMap['total'];
      print('Total de conteúdos disponíveis: $totalContents');
      int pageCount = int.parse(dataMap['pagecount'].toString());
      print('Total de paginas disponíveis: $pageCount');


      //---------------------------------------------------------------------------


      // Obtém o primeiro item da lista
      Map<String, dynamic> firstItem = dataMap['list'][0];

      // Itera sobre os atributos e imprime
      firstItem.forEach((key, value) {
        print('$key: $value');

      });

      //pega a URL
      print("URL é:" + firstItem["vod_pic"]);

      Map<String, dynamic> detalheConteudo = json.decode(data);
      List<dynamic> dataList = detalheConteudo['list'];
      List<String> playURLs =[];
      for (var item in dataList) {
        if (item.containsKey('vod_play_url')) {
           playURLs = item['vod_play_url'].split('#');

          int totalEpisodios = playURLs.length;
          print("Total Episodios:" +totalEpisodios.toString());

          for (var url in playURLs) {
            List<String> parts = url.split(r'$');
              String episodeDescription = parts[0];
              String contentType = totalEpisodios == 1? "Filme": "Serie";
              String contentURL = parts[1];

              print('Tipo: $contentType');
              print('Episodio: $episodeDescription');
              print('URL: $contentURL');
            }
          }
        }
      //Preencher o Filme com o resultado da busca
      Movie filmeEncontrado = Movie.fromJson(firstItem);
      //filmeEncontrado.url = playURLs;

      setState(() {
        _filme = filmeEncontrado!;
        print("vai tome");
        print(_filme.movietoString());

      });


      //---------------------------------------------------------------------------

    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }

  }

  void consultaCategoriasAPI() async{

    var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Se a solicitação for bem-sucedida, analise os dados JSON
      var data = response.body;
      // Faça algo com os dados aqui

      Map<String, dynamic> dataMap = json.decode(data);

      //Obtem o total de conteúdos disponiveis
      int totalContents = dataMap['total'];
      print('Total de conteúdos disponíveis: $totalContents');
      int pageCount = int.parse(dataMap['pagecount'].toString());
      print('Total de paginas disponíveis: $pageCount');


      //---------------------------------------------------------------------------

      //Separar as categorias
      //type_id = ID da Categoria
      //type_pid = ID da Categoria Macro
      //type_name = nome da categoria

      List<Map<String, dynamic>> movieCategories = [];
      List<Map<String, dynamic>> seriesCategories = [];
      List<Map<String, dynamic>> animationCategories = [];

      List<dynamic> categories = dataMap['class'];
      for (var category in categories) {
        if (category['type_pid'] == 1) {
          movieCategories.add(category);
          } else if (category['type_pid'] == 2) {
            seriesCategories.add(category);
          } else if (category['type_pid'] == 3) {
            animationCategories.add(category);
          }
        }

      print('Categorias de Filmes:');
      print(movieCategories);

      print('Categorias de Séries:');
      print(seriesCategories);

      print('Categorias de Animação:');
      print(animationCategories);

      setState(() {
        _movieCategories = movieCategories;
        _seriesCategories = seriesCategories;
        _animationCategories = animationCategories;
      });

      // Inicia com todas as categorias visíveis
      filteredCategories = _movieCategories..sort((a, b) => a['type_name'].compareTo(b['type_name']));
      _addTodosOsConteudos(); // Adiciona a categoria especial no início
      searchController.addListener(() {
        filterCategories();
      });


      //---------------------------------------------------------------------------

    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }

  }

  void consultaPorCategoriaAPI(String idConteudo) async{

    var apiBASE = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo
    var apiUrl = apiBASE + "?ac=videolist&t=" +idConteudo; //tudo
    print(apiUrl);
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Se a solicitação for bem-sucedida, analise os dados JSON
      var data = response.body;
      // Faça algo com os dados aqui

      Map<String, dynamic> dataMap = json.decode(data);

      //Obtem o total de conteúdos disponiveis
      int totalContents = dataMap['total'];
      print('Total de conteúdos disponíveis: $totalContents');
      int pageCount = int.parse(dataMap['pagecount'].toString());
      print('Total de paginas disponíveis: $pageCount');


      //---------------------------------------------------------------------------

      List<dynamic> allContent = [];
      // Itera sobre todas as páginas para obter o conteúdo
      for (int page = 1; page <= pageCount; page++) {
        final pageUrl = apiUrl + '&pg=$page';
        final pageResponse = await http.get(Uri.parse(pageUrl));
        final Map<String, dynamic> pageData = json.decode(pageResponse.body);
        final List<dynamic> content = pageData['list'];

        allContent.addAll(content);
      }

      // Converte o conteúdo combinado de todas as páginas em JSON
      final combinedContentJson = json.encode(allContent);

      List<dynamic> contentList = json.decode(combinedContentJson);

      print("Total de conteudos" + contentList.length.toString());

      // Iterando pelos elementos da lista e imprimindo
      List<Movie> listaFilmes =[];
      for (var content in contentList) {
    //    print(content);

        //Preencher o Filme com o resultado da busca
        listaFilmes.add(Movie.fromJson(content)) ;

      }

      print("TermineiCaraio todos os filmes da categoria:" +contentList.length.toString());
      print("TermineiCaraio lista de filmes feita:" +listaFilmes.length.toString());

      setState(() {
        _contentList = contentList;
        _contentListFiltered = _contentList;
        _listaFilmes = listaFilmes;
      });


      //---------------------------------------------------------------------------

    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }

  }

  void consultaPorCategoriaBaseLocal(String idConteudo) async{

    // Faça algo com os dados aqui

    List<dynamic> allContent = _contentList;

    //Obtem o total de conteúdos disponiveis
    int dataCount = _contentList.length;
    print('Total de conteudo disponível na base grandona: $dataCount');

    // Itera sobre todas os dados para obter o conteúdo filtrado
    List<dynamic> filteredContent = allContent.where((item) {
      return item['type_id'].toString() == idConteudo;
    }).toList();

    print("Total de conteudos" + filteredContent.length.toString());

    // Iterando pelos elementos da lista e imprimindo
    List<Movie> listaFilmes =[];
    for (var content in filteredContent) {
      //    print(content);

      //Preencher o Filme com o resultado da busca
      listaFilmes.add(Movie.fromJson(content)) ;

    }

    print("TermineiCaraio todos os filmes da categoria:" +filteredContent.length.toString());
    print("TermineiCaraio lista de filmes feita:" +listaFilmes.length.toString());

    setState(() {
      _contentListFiltered = filteredContent;
      _listaFilmes = listaFilmes;
    });


    //---------------------------------------------------------------------------


  }


  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
  }

  void checkContentAvailability() {
    if (_movieCategories != null && _movieCategories!.isNotEmpty &&
        _seriesCategories != null && _seriesCategories!.isNotEmpty &&
        _animationCategories != null && _animationCategories!.isNotEmpty &&
        _filme != null ) {
      setState(() {
        _allowContent = true;
      });
    } else {
      setState(() {
        _allowContent = false;
      });
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();

    consultaCategoriasAPI();
    consultaPorCategoriaAPI("12");
  //  fetchAPI();
    // consultaUnitariaAPI("7134");
   // checkContentAvailability();

  }



  void filterCategories() {
    List<Map<String, dynamic>> results = [];
    if (searchController.text.isEmpty) {
      results = _movieCategories;
    } else {
      results = _movieCategories
          .where((category) =>
          category['type_name'].toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    }
    results.sort((a, b) => a['type_name'].compareTo(b['type_name']));


    setState(() {
      filteredCategories = results;
    //  _addTodosOsConteudos();
    });

  }

  // Função para adicionar a categoria "Todos os conteúdos"
  void _addTodosOsConteudos() {
    if (!filteredCategories.any((category) => category['type_name'] == 'TODOS OS CONTEÚDOS')) {
      filteredCategories.insert(0, {
        'type_id': -1, // Um ID que não será conflitante com outros IDs reais
        'type_name': 'Todos os conteúdos'
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
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset:
      false,
         appBar: AppBar(
           shadowColor: shadowColorDark,
           backgroundColor: backgroundColor2,
           leading: Icon(Icons.arrow_back),
           title: Text("Stream 4U", style: TextStyle(
               fontSize: 25, fontFamily: "Poppins", height: 1.2),),
           actions: [
             IconButton(
                 onPressed: (){}, icon: Icon(Icons.search)
             ),
             IconButton(
                 onPressed: (){
                   setState(() {
                     isVisible = !isVisible;
                   });
                 }, icon: Icon((isVisible? Icons.visibility: Icons.visibility_off))
             ),
             PopupMenuButton<String>(
               onSelected: (value) {
                 setState(() {
                   if (value == 'toggle_captions') {
                     isSubtitleOn = !isSubtitleOn;
                   }
                   // Aqui você pode adicionar mais opções e suas respectivas ações
                 });
               },
               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                 PopupMenuItem<String>(
                   value: 'toggle_captions',
                   child: Text(isSubtitleOn ? 'Ocultar Legendas' : 'Exibir Legendas'),
                 ),
                 // Adicione mais PopupMenuItem se precisar de mais opções
               ],
               icon: Icon(Icons.more_vert),
             ),
           ],
         ),
         body: Row(
           children: [
            Visibility(
                visible: isVisible,
                child: Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        color: backgroundColor2,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: shadowColorLight,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.search),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: backgroundColor2,
                          child: ListView.builder(
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              var category = filteredCategories[index];
                              return ListTile(
                                title: Text(
                                    filteredCategories[index]['type_name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins"
                                  ),
                                ),
                                onTap: () {
                                  // Aqui você tem o type_id da categoria clicada
                                  print("Categoria clicada: ${category['type_name']}, ID: ${category['type_id']}");
                                  // Você pode fazer o que quiser com o type_id aqui
                                  setState(() {
                                   // consultaPorCategoriaAPI(category['type_id'].toString());
                                    consultaPorCategoriaBaseLocal(category['type_id'].toString());
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ),
             Expanded(
               flex: 6,
               child: Container(
                 color: shadowColorLight,
                 child: GridView.count(
                   crossAxisCount: isVisible == true? 4 :5, // 4 com a barra, 5 sem a brra
                   children:
                   _listaFilmes.map((Movie filme){
                     return MovieCard(
                       urlPic: filme.pictureURL,
                       title: filme.title,
                       subTitle: filme.subtitle,
                       year: filme.year,
                       rating: double.parse(filme.rating),
                       subtitleOn: isSubtitleOn,
                       starSize: 12,
                     );
                   }).toList(),
                 ),
               ),
             )
           ],
         ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: "Home"
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.search),
      //         label: "Search"
      //     ),
      //   ],
      // ),
      // body: Center(
      //   child: SingleChildScrollView(
      //     child: MovieCard(
      //         urlPic: _filme.pictureURL,
      //         title: _filme.title,
      //         subTitle: _filme.subtitle,
      //         year: _filme.year,
      //         rating: double.parse(_filme.rating),
      //       subtitleOn: true,
      //     ),
      //   ),
      // ),
    );
  }
}
