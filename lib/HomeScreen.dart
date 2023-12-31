import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream4u/LiveContent.dart';
import 'package:stream4u/VodContent.dart';
import 'package:stream4u/components/customCard.dart';
import 'package:stream4u/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream4u/models/PlaylistItem.dart';
import 'package:stream4u/models/channel.dart';
import 'package:stream4u/models/movie.dart';
import 'package:stream4u/onboding_screen.dart';

class HomeScreen extends StatefulWidget {
  final DateTime expirationDate;
  const HomeScreen({Key? key, required this.expirationDate}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> _contentList = [];
  String _formattedDate = "";
  String _respomse = "";
  late List<PlaylistItem> _playlist;
  List<Map<String, dynamic>> _movieCategories = [];
  List<Map<String, dynamic>> _seriesCategories = [];
  List<Map<String, dynamic>> _animationCategories = [];
  late List<Movie> _listaFilmes;


  Future<bool> _fetchAPI() async {

   // var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo
    var apiBASE = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo
    var apiUrl = apiBASE + "?ac=videolist"; //tudo
    var response = await http.get(Uri.parse(apiUrl));

    _getTVData();

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
     // for (int page = 1; page <= 5; page++) {
      //  final pageUrl = apiUrl + '?pg=$page';
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
      // for (var content in contentList) {
      //   print(content);
      //
      // }

      print("Busca Completa Realizada!");


      //Iterar para preencher a lista Filmes
    //   List<Movie> listaFilmes;
    //
    //   listaFilmes = converterParaListaFilmes(contentList);
    //
    //   print(contentList.first.toString());
    //
    //   print("Filmes convertidos");
    //  // print(listaFilmes.toString());
    //  // print(listaFilmes.first.movietoString());
    //
    // setState(() {
    // _listaFilmes = listaFilmes;
    // });


   //   consultaCategoriasAPI();


      //++++++++++++++++++++++++++++++++++++++++++++

      apiUrl = apiBASE ; //tudo
     var response2 = await http.get(Uri.parse(apiUrl));

      if (response2.statusCode == 200) {
        // Se a solicitação for bem-sucedida, analise os dados JSON
        var data = response2.body;
        // Faça algo com os dados aqui
        // print(data);
        Map<String, dynamic> dataMap = json.decode(data);


        // Recuperar categorias

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


        // Inicia com todas as categorias visíveis
        movieCategories = movieCategories
          ..sort((a, b) => a['type_name'].compareTo(b['type_name']));
        seriesCategories = seriesCategories
          ..sort((a, b) => a['type_name'].compareTo(b['type_name']));
        animationCategories = animationCategories
          ..sort((a, b) => a['type_name'].compareTo(b['type_name']));

        // Adiciona a categoria especial no início
        _addTodosOsConteudos(movieCategories);
        _addTodosOsConteudos(seriesCategories);
        _addTodosOsConteudos(animationCategories);

        setState(() {
          _movieCategories = movieCategories;
          _seriesCategories = seriesCategories;
          _animationCategories = animationCategories;
        });

        print("Categorias recuperadas!");
      }
      else {
        // Se a solicitação não for bem-sucedida, lide com o erro
        print('Erro ao acessar a API: ${response2.statusCode}');
      }

      //++++++++++++++++++++++++++++++++++++++++++++


      setState(() {
        _contentList = contentList;
      });

      print("content list: " +_contentList.toString());

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

      setState(() {
        _formattedDate = formattedDate;
      });

      _saveData(contentList, formattedDate, _movieCategories, _seriesCategories, _animationCategories, _playlist);


    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }

    return true;
  }

  void consultaCategoriasAPI() async{

    var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Se a solicitação for bem-sucedida, analise os dados JSON
      var data = response.body;
      // Faça algo com os dados aqui

      Map<String, dynamic> dataMap = json.decode(data);


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


      // Inicia com todas as categorias visíveis
      movieCategories = movieCategories..sort((a, b) => a['type_name'].compareTo(b['type_name']));
      seriesCategories = seriesCategories..sort((a, b) => a['type_name'].compareTo(b['type_name']));
      animationCategories = animationCategories..sort((a, b) => a['type_name'].compareTo(b['type_name']));

      // Adiciona a categoria especial no início
      _addTodosOsConteudos(movieCategories);
      _addTodosOsConteudos(seriesCategories);
      _addTodosOsConteudos(animationCategories);

      setState(() {
        _movieCategories = movieCategories;
        _seriesCategories = seriesCategories;
        _animationCategories = animationCategories;
      });

      print("Categorias recuperadas!");

      //---------------------------------------------------------------------------

    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }

  }

  // Função para adicionar a categoria "Todos os conteúdos"
  List<Map<String, dynamic>> _addTodosOsConteudos(List<Map<String, dynamic>> categories) {
    if (!categories.any((category) => category['type_name'] == 'TODOS OS CONTEÚDOS')) {
      categories.insert(0, {
        'type_id': -1, // Um ID que não será conflitante com outros IDs reais
        'type_name': 'Todos os conteúdos'
      });
    }
    if (!categories.any((category) => category['type_name'] == 'FAVORITOS')) {
      categories.insert(0, {
        'type_id': -2, // Um ID que não será conflitante com outros IDs reais
        'type_name': 'Favoritos'
      });
    }
    return categories;
  }

  void _saveData(List<dynamic> contentList, String formattedDate, List<Map<String, dynamic>> movieCategories, List<Map<String, dynamic>> seriesCategories, List<Map<String, dynamic>> animationCategories, List<PlaylistItem> playlistTV) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String contentListJson = json.encode(contentList);
    prefs.setString('contentList', contentListJson);
    prefs.setString('formattedDate', formattedDate);

    String movieCategoriesJson = json.encode(movieCategories);
    prefs.setString('movieCategories', movieCategoriesJson);

    String seriesCategoriesJson = json.encode(seriesCategories);
    prefs.setString('seriesCategories', seriesCategoriesJson);

    String animationCategoriesJson = json.encode(animationCategories);
    prefs.setString('animationCategories', animationCategoriesJson);

    // Converte a lista de PlaylistItem para uma lista de Map
    List<Map<String, dynamic>> playlistData = playlistTV.map((item) => item.toMap()).toList();
    // Converte a lista de Map para uma lista de String
    List<String> playlistTVJson = playlistData.map((map) => json.encode(map)).toList();

    prefs.setStringList('playlistTV', playlistTVJson);
  }


  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contentListJson = prefs.getString('contentList');
    String? storedFormattedDate = prefs.getString('formattedDate');
    String? movieCategoriesJson = prefs.getString('movieCategories');
    String? seriesCategoriesJson = prefs.getString('seriesCategories');
    String? animationCategoriesJson = prefs.getString('animationCategories');
    List<String>? playlistTVJson = prefs.getStringList('playlistTV');

    if (contentListJson != null &&
        storedFormattedDate != null &&
        movieCategoriesJson != null &&
        seriesCategoriesJson != null &&
        animationCategoriesJson != null &&
        playlistTVJson != null) {
      List<dynamic> contentList = json.decode(contentListJson);
      List<Map<String, dynamic>> movieCategories =
      List<Map<String, dynamic>>.from(json.decode(movieCategoriesJson));
      List<Map<String, dynamic>> seriesCategories =
      List<Map<String, dynamic>>.from(json.decode(seriesCategoriesJson));
      List<Map<String, dynamic>> animationCategories =
      List<Map<String, dynamic>>.from(json.decode(animationCategoriesJson));
      final playlistTV = playlistTVJson.map((item) => PlaylistItem.fromMap(item)).toList();


      print("Dados carregados da memória com sucesso");

      setState(() {
        _contentList = contentList;
        _formattedDate = storedFormattedDate;
        _movieCategories = movieCategories;
        _seriesCategories = seriesCategories;
        _animationCategories = animationCategories;
        _playlist = playlistTV;
       //_allowContent = true;
      });
    } else {
      print("Sem dados na memória");
    }
  }

  List<Movie> converterParaListaFilmes(List<dynamic> contentList, List<Map<String, dynamic>> categories){

    List<Movie> listaConteudos =[];

    //Iterando pelos elementos da lista para filtrar

    for (var category in categories) {
      // Obtendo o type_id da categoria atual
      int categoryId = category['type_id'];

      // Filtrando os conteúdos com base no type_id da categoria atual
      List<dynamic> filteredContent = contentList.where((content) {
        return content['type_id'] == categoryId;
      }).toList();

      // Convertendo os conteúdos filtrados em objetos Movie e adicionando à lista final
      for (var content in filteredContent) {
        listaConteudos.add(Movie.fromJson(content));
      }

    }

    return listaConteudos;
  }

  List<Channel> converterParaListaCanais(List<PlaylistItem> playlist){

    return playlist.map((item) {
      return Channel(
        title: item.title,
        category: item.category,
        pictureURL: item.logoUrl, // Use 'logoUrl' como URL da imagem
        url: item.url,
      );
    }).toList();
  }

  void _waitingAPI() async{
    DateTime dataInicio = DateTime.now();
    int minutos = 0;
    int segundos = 0;
    showDialog(
      context: context,
      barrierDismissible: false, // Impede o fechamento do diálogo ao tocar fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aguarde...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Atualizando a base de dados.'),
              Text('Isso pode levar 4 minutos'),
              SizedBox(height: 10,),
              CircularProgressIndicator(), // Indicador de progresso
            ],
          ),
        );
      },
    );

    try {

      bool api = await _fetchAPI();
      try {
        if (api = true){
          DateTime dataFim = DateTime.now();
          // Calcule a diferença

          Duration diferenca = dataFim.difference(dataInicio);

          // Obtenha os minutos e segundos
          minutos = diferenca.inMinutes;
          segundos = diferenca.inSeconds % 60;

           Navigator.of(context).pop();


        }
      } catch (e){
        return;
      }
    } catch (e) {
      print('Erro ao acessar a API: $e');
    } finally {;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Os dados foram atualizados com sucesso.'),
                SizedBox(height: 8,),
                Text('Levou $minutos minutos e $segundos segundos'),
                SizedBox(height: 8,),
                Text('Última atualização: $_formattedDate'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o AlertDialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Função para converter uma string de data para DateTime
  DateTime converterStringParaDateTime(String dataString) {
    // Divida a string em partes (dia, mês, ano, hora, minuto)
    List<String> partes = dataString.split(' ');

    // Divida a parte da data em dia, mês e ano
    List<String> dataPartes = partes[0].split('/');
    int dia = int.parse(dataPartes[0]);
    int mes = int.parse(dataPartes[1]);
    int ano = int.parse(dataPartes[2]);

    // Divida a parte da hora em hora e minuto
    List<String> horaPartes = partes[1].split(':');
    int hora = int.parse(horaPartes[0]);
    int minuto = int.parse(horaPartes[1]);

    // Crie o objeto DateTime
    DateTime data = DateTime(ano, mes, dia, hora, minuto);

    return data;
  }

  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<String> baixarArquivoM3U(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // O arquivo .m3u está no corpo da resposta
      // List<PlaylistItem> playlist = parseM3U(response.body);
      // setState(() {
      //   _playlist = playlist;
      // });
      // print(_playlist);
    //  print('Conteúdo Original:\n${response.body}\n');

      return response.body;
    } else {
      // Se a solicitação falhar, você pode lidar com isso aqui
      throw Exception('Falha ao baixar o arquivo .m3u');
    }
  }

  _getTVData() async {
    String  url = "http://iptv.cineliso.com:80/get.php?username=cinelisotv&password=baximovi&type=m3u_plus&output=hls";
    String getData = await baixarArquivoM3U(url);
    List<PlaylistItem> getLista = [];
    getLista = await parseM3U(getData);
    print("total items " +getLista.length.toString());
    for (PlaylistItem item in getLista) {
      print('Title: ${item.title}');
      print('Logo URL: ${item.logoUrl}');
      print('URL: ${item.url}');
      print('Category: ${item.category}');
      print('---');  // Apenas para separar os itens
    }
    setState(() {
      _playlist = getLista;
    });
  }

  Future<void> _signOut() async {

      await FirebaseAuth.instance.signOut();
      //Limpar tokens do login automatico

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', "false");
      await prefs.setString('user', "");
      await prefs.setString('pass', "");

      print('Usuário deslogado com sucesso.');
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => OnboardingScreen()));


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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();
    loadData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Stream 4U",
                  style: TextStyle(
                      fontSize: 25, fontFamily: "Poppins", height: 1.2,color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white,),
                      onPressed: (){
                        _waitingAPI();
                      },
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() {
                          if (value == 'logout') {
                            _signOut();
                          }

                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Log Out'),
                        )
                        // Outros itens do menu popup
                      ],
                      icon: Icon(Icons.person, color: Colors.white,),
                    )
                  ],
                )
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
           // childAspectRatio: 3/2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: EdgeInsets.all(20),
            children: [
              CustomCard( icon: Icons.live_tv, lable: "Live TV", coresGradiente: [Colors.green, Colors.blue],callback: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveContent(
                      playlist: _playlist,
                      listaCanais: converterParaListaCanais(_playlist)
                    ),
                  ),
                );

              }),
              CustomCard( icon: Icons.movie, lable: "Filmes", coresGradiente: [Colors.redAccent, Colors.orange],callback: (){

                if (_contentList.isNotEmpty && _movieCategories.isNotEmpty) {
                  print("passei aqui tambem Filmes");
                  print(_movieCategories.toString());
                 // print(_contentList.toString());
                //  print(converterParaListaFilmes(_contentList).toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VodContent(
                        contentList: _contentList,
                        category: "Filmes",
                        contentCategories: _movieCategories,
                        //listaFilmes: _listaFilmes,
                        listaFilmes: converterParaListaFilmes(_contentList, _movieCategories),
                      ),
                    ),
                  );
                }
              }),
              CustomCard( icon: Icons.tv, lable: "Séries", coresGradiente: [Colors.deepPurpleAccent, Colors.blue],callback: (){

                if (_contentList.isNotEmpty && _seriesCategories.isNotEmpty) {
                  print("passei aqui tambem");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VodContent(
                          contentList: _contentList,
                          category: "Séries",
                          contentCategories: _seriesCategories,
                          listaFilmes: converterParaListaFilmes(_contentList, _seriesCategories),
                      ),
                    ),
                  );
                }

              }),
              CustomCard( icon: Icons.child_care, lable: "Animações", coresGradiente: [Colors.pinkAccent, Colors.red],callback: (){
                if (_contentList.isNotEmpty && _animationCategories.isNotEmpty) {
                  print("passei aqui tambem");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VodContent(
                          contentList: _contentList,
                          category: "Animações",
                          contentCategories: _animationCategories,
                          listaFilmes: converterParaListaFilmes(_contentList, _animationCategories),
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expiração: "+widget.expirationDate.toLocal().day.toString()+"/"+widget.expirationDate.toLocal().month.toString()+"/"+widget.expirationDate.toLocal().year.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Última atualização: " +(_formattedDate ==""? "Atualize o app no botão acima!":_formattedDate),
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
