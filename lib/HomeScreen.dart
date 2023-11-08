import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stream4u/VodContent.dart';
import 'package:stream4u/components/customCard.dart';
import 'package:stream4u/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> _contentList = [];
  String _formattedDate = "";


  void _fetchAPI() async {

    var apiUrl = "https://api.cinelisoapi.com/api.php/provide/vod/"; //tudo
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
      // for (var content in contentList) {
      //   print(content);
      //
      // }

      print("Busca Completa Realizada!");

      setState(() {
        _contentList = contentList;
      });

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

      setState(() {
        _formattedDate = formattedDate;
      });

      _saveData(contentList, formattedDate);

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
                Text('Última atualização: $formattedDate'),
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


    } else {
      // Se a solicitação não for bem-sucedida, lide com o erro
      print('Erro ao acessar a API: ${response.statusCode}');
    }
  }

  void _saveData(List<dynamic> contentList, String formattedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String contentListJson = json.encode(contentList);
    prefs.setString('contentList', contentListJson);
    prefs.setString('formattedDate', formattedDate);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contentListJson = prefs.getString('contentList');
    String? storedFormattedDate = prefs.getString('formattedDate');

    if (contentListJson != null && storedFormattedDate != null) {
      List<dynamic> contentList = json.decode(contentListJson);
      print("dados carregados da memoria com sucesso");
      setState(() {
        _contentList = contentList;
        _formattedDate = storedFormattedDate;
      //  _allowContent = true;
      });
    } else {
      print("sem dados na memoria");
    }
  }

  void _waintingAPI() async{
    showDialog(
      context: context,
      barrierDismissible: false, // Impede o fechamento do diálogo ao tocar fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aguarde...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Atualizando a base de dados.'),
              CircularProgressIndicator(), // Indicador de progresso
            ],
          ),
        );
      },
    );

    try {
      _fetchAPI();
    } catch (e) {
      print('Erro ao acessar a API: $e');
    } finally {
      Navigator.of(context).pop(); // Fecha o AlertDialog após a conclusão do processamento
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        _waintingAPI();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.white,),
                      onPressed: (){},
                    ),
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
              CustomCard( icon: Icons.live_tv, lable: "Live TV", coresGradiente: [Colors.green, Colors.blue],callback: (){}),
              CustomCard( icon: Icons.movie, lable: "Filmes", coresGradiente: [Colors.redAccent, Colors.orange],callback: (){
                if (_contentList.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VodContent(
                        //contentList: _contentList,
                       // category: "Filmes",
                      ),
                    ),
                  );
                }
              }),
              CustomCard( icon: Icons.tv, lable: "Séries", coresGradiente: [Colors.deepPurpleAccent, Colors.blue],callback: (){}),
              CustomCard( icon: Icons.child_care, lable: "Animações", coresGradiente: [Colors.pinkAccent, Colors.red],callback: (){}),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expiração xx/xx/xx",
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
