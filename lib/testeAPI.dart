import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stream4u/components/movie_card.dart';
import 'package:stream4u/components/star_calculator.dart';
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
  String _urlfilme = "https://www.cineliso.com/upload/vod/20231013-15/96e3fdae46f12bda1b4a7126ef0f258b.jpg";
  late Movie _filme;

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


      //---------------------------------------------------------------------------

    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  //  fetchAPI();
  //  consultaCategoriasAPI();
    consultaUnitariaAPI("7134");
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> stars = getStars(rating: 10, starSize: 2);

    return  Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: MovieCard(
              urlPic: _filme.pictureURL,
              title: _filme.title,
              subTitle: _filme.subtitle,
              year: _filme.year,
              rating: double.parse(_filme.rating),
            subtitleOn: true,
          ),
        ),
      ),
    );
  }
}
