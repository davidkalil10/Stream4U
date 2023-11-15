//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream4u/MovieScreen.dart';
import 'package:stream4u/components/movie_card.dart';
import 'package:stream4u/constants.dart';
import 'package:stream4u/models/movie.dart';

class VodContent extends StatefulWidget {
  final List<dynamic> contentList;
  final String category;
  final List<Map<String, dynamic>> contentCategories;
  final List<Movie> listaFilmes;


  VodContent({required this.contentList, required this.category, required this.contentCategories, required this.listaFilmes});

  @override
  State<VodContent> createState() => _VodContentState();
}

class _VodContentState extends State<VodContent> {

  bool isVisible = true;
  bool isSubtitleOn = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerFilmes = TextEditingController();
  List<Map<String, dynamic>> _filteredCategories = [];
  List<dynamic> _contentListFiltered = [];
  late List<Movie> _listaFilmes;
  late List<Movie> _filteredMovies;
  late List<Movie> _filteredMoviesBackup;
  bool _isSearchOpened = false;
  String _filteredCategoryName="Todos os Conteúdos";
  bool _ordemCrescente = true; // Flag para controlar a ordem (crescente ou decrescente)
  bool _escolherOrdem = false; // Flag para controlar se o usuário deve escolher a ordem
  List<String> _favoriteIds = [];

  String getCategoryNameById(int? categoryId, List<Map<String, dynamic>> categories) {
    for (var category in categories) {
      if (category['type_id'] == categoryId) {
        return category['type_name'];
      }
    }
    return 'Categoria não encontrada'; // ou null, dependendo do caso
  }

  Future<List<String>> _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _favoriteIds = prefs.getStringList('favorites') ?? [];
    });
    return
      prefs.getStringList('favorites') ?? [];
  }

  void consultaPorCategoriaBaseLocal(String idConteudo) async{

    print("meu id é:");
    print(idConteudo);

    // Faça algo com os dados aqui

    List<dynamic> allContent = widget.contentList;

    //Obtem o total de conteúdos disponiveis
    int dataCount = widget.contentList.length;
    print('Total de conteudo disponível na base grandona: $dataCount');
    String nomeCategoria = getCategoryNameById((int.tryParse(idConteudo)),_filteredCategories);


    if ((idConteudo != "-1") && (idConteudo != "-2") ){
        print("ok");
      // Itera sobre todas os dados para obter o conteúdo filtrado
      List<dynamic> filteredContent = allContent.where((item) {
        return item['type_id'].toString() == idConteudo;
      }).toList();

      print("Total de conteudos da categoria escolhida: " + filteredContent.length.toString());

      // Iterando pelos elementos da lista e imprimindo
      List<Movie> listaFilmes =[];
      for (var content in filteredContent) {
        //    print(content);

        //Preencher o Filme com o resultado da busca
        listaFilmes.add(Movie.fromJson(content)) ;

      }

      print("Todos os filmes da categoria: " +filteredContent.length.toString());
      print("Lista de filmes feita com: " +listaFilmes.length.toString());

      setState(() {
        _contentListFiltered = filteredContent;
        _listaFilmes = listaFilmes;
        _filteredMovies = _listaFilmes;
        _filteredMoviesBackup = _listaFilmes;
        _filteredCategoryName = nomeCategoria;
      });

    }else if (idConteudo == "-1"){
      print("passei no total");
      //Clicado em todas os conteúdos
      setState(() {
        _contentListFiltered = widget.contentList;
        _listaFilmes = widget.listaFilmes;
        _filteredMovies = _listaFilmes;
        _filteredMoviesBackup = _listaFilmes;
        _filteredCategoryName = "Todos os Conteúdos";
      });

    } else{
      // Clicado nos favoritos

      // Recupere a lista de favoritos
      List<String> favoriteIds = await _getFavorites();
      print(favoriteIds);

      // Filtre a lista de filmes exibindo apenas os favoritos
      // Iterando pelos elementos da lista e imprimindo
      List<Movie> listaFilmes =[];
      for (var content in allContent) {
        //    print(content);
        //Preencher o Filme com o resultado da busca
        listaFilmes.add(Movie.fromJson(content)) ;
      }

      List<Movie> favoriteMovies = listaFilmes.where((movie) => favoriteIds.contains(movie.id.toString())).toList();

      setState(() {
        _contentListFiltered = widget.contentList;
        _listaFilmes = favoriteMovies;
        _filteredMovies = _listaFilmes;
        _filteredMoviesBackup = _listaFilmes;
        _filteredCategoryName = "Favoritos";
      });

    }


  }

  List<Movie> converterParaListaFilmes(List<dynamic> contentList){

    // Iterando pelos elementos da lista e imprimindo
    List<Movie> listaFilmes =[];
    for (var content in contentList) {
      //    print(content);

      //Preencher o Filme com o resultado da busca
      listaFilmes.add(Movie.fromJson(content)) ;

    }

    return listaFilmes;

  }

  void filterCategories() {
    List<Map<String, dynamic>> results = [];
    if (searchController.text.isEmpty) {
      results = widget.contentCategories;
    } else {
      results = widget.contentCategories
          .where((category) =>
          category['type_name'].toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
      results.sort((a, b) => a['type_name'].compareTo(b['type_name']));
    }



    setState(() {
      _filteredCategories = results;
      //  _addTodosOsConteudos();
    });

  }

  void filterMovies() {
    List<Movie> filteredMovies = [];
    print("to tentando ein");

    if (searchControllerFilmes.text.isEmpty) {
      filteredMovies = _filteredMovies;
    } else {
      filteredMovies = _filteredMovies.where((movie) {
        return movie.title.toLowerCase().contains(searchControllerFilmes.text.toLowerCase());
      }).toList();
    }

    setState(() {
      _filteredMoviesBackup = filteredMovies;
    });
  }

  void _sortMovies(String criterio) {
    List<Movie> filteredMovies = [];

    if (criterio== "title"){
      filteredMovies = _filteredMovies..sort((a, b) => a.title.compareTo(b.title));
    } else if (criterio== "ano"){
      filteredMovies = _filteredMovies..sort((a, b) => b.year.compareTo(a.year));
    }else if (criterio== "avaliacoes"){
      filteredMovies = _filteredMovies..sort((a, b) => b.rating.compareTo(a.rating));
    }

    if (!_ordemCrescente){
      filteredMovies = filteredMovies.reversed.toList();
    }

    setState(() {
      _filteredMoviesBackup = filteredMovies;
    });
  }

  void _mostrarDialogClassificacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha a Classificação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Ordem:'),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      _alterarOrdem(); // Ordem crescente (A>Z)
                    },
                    child: _ordemCrescente
                        ? Icon(Icons.arrow_upward, color: Colors.blue)
                        : Icon(Icons.arrow_downward, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              _opcaoClassificacao('Ordem Alfabética', 'title'),
              SizedBox(height: 10,),
              _opcaoClassificacao('Ano de Lançamento', 'ano'),
              SizedBox(height: 10,),
              _opcaoClassificacao('Avaliações', 'avaliacoes'),
            ],
          ),
        );
      },
    );
  }

  Widget _opcaoClassificacao(String label, String criterio) {
    return
      InkWell(
        onTap: () {
          _escolherOrdem = true; // Permitir escolher a ordem
          _sortMovies(criterio);
          Navigator.pop(context);
        },
        child: Text(label),
      );
  }

  void _alterarOrdem() {
    // Função para alterar a ordem visualmente na dialog
    print("ordem atual:" + _ordemCrescente.toString());
    setState(() {
      _ordemCrescente = !_ordemCrescente;
    });
    print("ordem final:" + _ordemCrescente.toString());
    Navigator.pop(context);
    _mostrarDialogClassificacao();
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
    searchController.dispose();
    searchControllerFilmes.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();
    _contentListFiltered = widget.contentList;
    _listaFilmes = widget.listaFilmes;
    _filteredMovies = widget.listaFilmes;
    _filteredMoviesBackup = widget.listaFilmes;
    _filteredCategories = widget.contentCategories;
    //_listaFilmes = converterParaListaFilmes(widget.contentList);
    _getFavorites();

    setState(() {
      _contentListFiltered = widget.contentList;
      _listaFilmes = widget.listaFilmes;
      _filteredMovies = widget.listaFilmes;
      _filteredMoviesBackup = widget.listaFilmes;
      _filteredCategories = widget.contentCategories;
      //_listaFilmes = converterParaListaFilmes(widget.contentList);
    });

    print("categorias recebidas");
    print(_filteredCategories.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
      false,
      appBar: AppBar(
        shadowColor: shadowColorDark,
        backgroundColor: backgroundColor2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Fecha a janela e retorna para a tela anterior
          },
        ),
        // title: Text("Stream 4U", style: TextStyle(
        //     fontSize: 25, fontFamily: "Poppins", height: 1.2),),
        title:  _isSearchOpened == false
            ? Row(
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
              _filteredCategoryName,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                height: 1.2,
              ),
            ),
            SizedBox(width: 1,)
          ],
        )
        :Row(
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
            SizedBox(width: 1,)
          ],
        ),
        actions:   [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchOpened = !_isSearchOpened;
              });
            },
            icon: _isSearchOpened ? Icon(Icons.arrow_back) : Icon(Icons.search),
          ),
          if (_isSearchOpened)
            SizedBox(
              width: 480,
              child: TextField(
                controller: searchControllerFilmes,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: 'Pesquisar '+widget.category,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              fillColor: backgroundColor2,
              ),
                autofocus: true, // Esta propriedade moverá o foco para o campo de texto
                // Implemente a lógica de filtragem com base no texto inserido
                onChanged: (String value) {
                  // Lógica de filtragem
                  filterMovies(); // Chama o filtro quando o texto muda
                },
              ),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'toggle_captions') {
                  isSubtitleOn = !isSubtitleOn;
                }
                if (value == 'ordering') {
                  //chmar alert de classificação
                  _mostrarDialogClassificacao();
                }
                // Outras ações do menu popup
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'toggle_captions',
                child: Text(isSubtitleOn ? 'Ocultar Legendas' : 'Exibir Legendas'),
              ),
              PopupMenuItem<String>(
                value: 'ordering',
                child: Text('Classificar'),
              )
              // Outros itens do menu popup
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
                        onChanged: (value) {
                          filterCategories(); // Chama o filtro quando o texto muda
                        },
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
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          var category = _filteredCategories[index];
                          return ListTile(
                            title: Text(
                              _filteredCategories[index]['type_name'],
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
          // Expanded(
          //   flex: 6,
          //   child: Container(
          //     color: shadowColorLight,
          //     child: GridView.count(
          //       crossAxisCount: isVisible == true? 4 :5, // 4 com a barra, 5 sem a barra
          //       children:
          //       _filteredMoviesBackup.map((Movie filme){
          //         return MovieCard(
          //           urlPic: filme.pictureURL,
          //           title: filme.title,
          //           subTitle: filme.subtitle,
          //           year: filme.year,
          //           rating: double.parse(filme.rating),
          //           subtitleOn: isSubtitleOn,
          //           starSize: 12,
          //         );
          //       }).toList(),
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 6,
            child: Container(
              color: shadowColorLight,
              child: GridView.builder(
                itemCount: _filteredMoviesBackup.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isVisible ? 4 : 5, // 4 com a barra, 5 sem a barra
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  var filme = _filteredMoviesBackup[index];

                  return  GestureDetector(
                    onDoubleTap: (){
                      print("Duplo no: ${filme.title}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieScreen(filme: filme),
                        ),
                      );
                    },
                    onLongPress: (){
                      print("Forçada no: ${filme.title}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieScreen(filme: filme),
                        ),
                      );
                    },
                    onTap: () {
                      // Seu código de navegação aqui
                      print("Cliquei no: ${filme.title}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieScreen(filme: filme),
                        ),
                      );
                    },
                    child: MovieCard(
                      urlPic: filme.pictureURL,
                      title: filme.title,
                      subTitle: filme.subtitle,
                      year: filme.year,
                      rating: double.parse(filme.rating),
                      subtitleOn: isSubtitleOn,
                      starSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
