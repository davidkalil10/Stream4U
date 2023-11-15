import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream4u/LiveScreen.dart';
import 'package:stream4u/components/channel_card.dart';
import 'package:stream4u/constants.dart';
import 'package:stream4u/models/PlaylistItem.dart';
import 'package:stream4u/models/channel.dart';

class LiveContent extends StatefulWidget {
  final List<PlaylistItem> playlist;
  final List<Channel> listaCanais;

  const LiveContent({Key? key, required this.playlist, required this.listaCanais}) : super(key: key);



  @override
  State<LiveContent> createState() => _LiveContentState();
}

class _LiveContentState extends State<LiveContent> {

  bool _isSearchOpened = false;
  bool isVisible = true;
  String _filteredCategoryName="Todos os Conteúdos";
  TextEditingController searchControllerCanais = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> _filteredCategories = [];
  List<String> _categories = [];
  late List<Channel> _listaCanais;
  late List<Channel> _filteredChannels;
  late List<Channel> _filteredChannelsBackup;

  void filterChannels(){
    List<Channel> filteredChannels = [];

    if (searchControllerCanais.text.isEmpty) {
      filteredChannels = _filteredChannels;
    } else {
      filteredChannels = _filteredChannels.where((canal) {
        return canal.title.toLowerCase().contains(searchControllerCanais.text.toLowerCase());
      }).toList();
    }

    setState(() {
      _filteredChannelsBackup = filteredChannels;
    });
  }

  void filterCategories(){
    List<String> results = [];
    if (searchController.text.isEmpty) {
      results = _categories;
    } else {
      results = _categories
          .where((category) =>
          category.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
      results.sort();
    }


    setState(() {
      _filteredCategories = results;
      //  _addTodosOsConteudos();
    });
  }

  List<String> _obterCategorias(List<PlaylistItem> playlist) {
    // Crie um conjunto para armazenar categorias únicas
    Set<String> categoriasUnicas = Set<String>();

    // Percorra a lista de reprodução e adicione as categorias ao conjunto
    for (var item in playlist) {
      categoriasUnicas.add(item.category);
    }
    // Converta o conjunto para uma lista e ordene alfabeticamente
    List<String> categoriasOrdenadas = categoriasUnicas.toList()..sort();

    //Add todos os conteúdos
    List<String> categoriasCompletas = _addTodosOsConteudos(categoriasOrdenadas);

    return categoriasCompletas;

  }

  // Função para adicionar a categoria "Todos os conteúdos"
  List<String> _addTodosOsConteudos(List<String> categories) {
    if (!categories.contains("TODOS OS CANAIS")) {
      categories.insert(0, 'TODOS OS CANAIS');
    }
    return categories;
  }


  void _consultaPorCategoriaBaseLocal(String categoria, int id) async{


    List<PlaylistItem> allContent = widget.playlist;

    //Obtem o total de conteúdos disponiveis
    int dataCount = widget.playlist.length;
    print('Total de conteudo disponível na base grandona: $dataCount');

    if (id != 0){

      // Itera sobre todas os dados para obter o conteúdo filtrado
      List<PlaylistItem> filteredContent = allContent.where((item) {
        return item.category == categoria;
      }).toList();

      print("Total de conteudos da categoria escolhida: " + filteredContent.length.toString());

      // Iterando pelos elementos da lista e imprimindo
      List<Channel> listaCanais =[];
      for (var content in filteredContent) {
        //    print(content);

        //Preencher o Filme com o resultado da busca
        listaCanais.add(Channel.fromPlaylist(content)) ;

      }

      print("Todos os filmes da categoria: " +filteredContent.length.toString());
      print("Lista de filmes feita com: " +listaCanais.length.toString());

      setState(() {
        _listaCanais = listaCanais;
        _filteredChannels = _listaCanais;
        _filteredChannelsBackup = _listaCanais;
        _filteredCategoryName = categoria;
      });

    }else{

      //Clicado em todas os conteúdos
      setState(() {
        _listaCanais = widget.listaCanais;
        _filteredChannels = _listaCanais;
        _filteredChannelsBackup = _listaCanais;
        _filteredCategoryName = "Todos os Conteúdos";
      });

    }


  }

  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setLandscapeOrientation();
    var categorias = _obterCategorias(widget.playlist);

    //_contentListFiltered = widget.contentList;
    _listaCanais = widget.listaCanais;
    _filteredChannels = widget.listaCanais;
    _filteredChannelsBackup = widget.listaCanais;
    _categories = categorias;
    _filteredCategories = _categories;

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
                controller: searchControllerCanais,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Pesquisar Canais',
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
                  filterChannels(); // Chama o filtro quando o texto muda
                },
              ),
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
                              _filteredCategories[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins"
                              ),
                            ),
                            onTap: () {
                              // Aqui você tem o type_id da categoria clicada
                              print("Categoria clicada: ${category}, ID: ${index} ");
                              // Você pode fazer o que quiser com o type_id aqui
                              setState(() {
                                // consultaPorCategoriaAPI(category['type_id'].toString());
                                _consultaPorCategoriaBaseLocal(category, index);
                                //add metodo para filtrar as categorias dos filmes
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
              child: GridView.builder(
                itemCount: _filteredChannelsBackup.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isVisible ? 4 : 5, // 4 com a barra, 5 sem a barra
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  var canal = _filteredChannelsBackup[index];


                  return  GestureDetector(
                    onTap: () {
                      // Seu código de navegação aqui
                      print("Cliquei no: ${canal.title}");
                      print("Cliquei no: ${canal.url}");
                      print("Cliquei no: ${canal.pictureURL}");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => LiveScreen(channelURL: canal.url,),
                      //   ),
                      // );
                    },
                    child: ChannelCard(
                      urlPic: canal.pictureURL,
                      title: canal.title,
                      category: canal.category,
                      url: canal.url,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );;
  }
}
