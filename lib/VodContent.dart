//import 'dart:html';

import 'package:flutter/material.dart';
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

  String getCategoryNameById(int? categoryId, List<Map<String, dynamic>> categories) {
    for (var category in categories) {
      if (category['type_id'] == categoryId) {
        return category['type_name'];
      }
    }
    return 'Categoria não encontrada'; // ou null, dependendo do caso
  }

  void consultaPorCategoriaBaseLocal(String idConteudo) async{

    // Faça algo com os dados aqui

    List<dynamic> allContent = widget.contentList;

    //Obtem o total de conteúdos disponiveis
    int dataCount = widget.contentList.length;
    print('Total de conteudo disponível na base grandona: $dataCount');
    String nomeCategoria = getCategoryNameById((int.tryParse(idConteudo)),_filteredCategories);


    if (idConteudo != "-1"){

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

    }else{

      //Clicado em todas os conteúdos
      setState(() {
        _contentListFiltered = widget.contentList;
        _listaFilmes = widget.listaFilmes;
        _filteredMovies = _listaFilmes;
        _filteredMoviesBackup = _listaFilmes;
        _filteredCategoryName = "Todos os Conteúdos";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentListFiltered = widget.contentList;
    _listaFilmes = widget.listaFilmes;
    _filteredMovies = widget.listaFilmes;
    _filteredMoviesBackup = widget.listaFilmes;
    _filteredCategories = widget.contentCategories;
    //_listaFilmes = converterParaListaFilmes(widget.contentList);

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
                // Outras ações do menu popup
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'toggle_captions',
                child: Text(isSubtitleOn ? 'Ocultar Legendas' : 'Exibir Legendas'),
              ),
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
          Expanded(
            flex: 6,
            child: Container(
              color: shadowColorLight,
              child: GridView.count(
                crossAxisCount: isVisible == true? 4 :5, // 4 com a barra, 5 sem a brra
                children:
                _filteredMoviesBackup.map((Movie filme){
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
    );
  }
}
