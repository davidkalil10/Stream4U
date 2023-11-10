import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
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

                                          });
                                        },
                                      ),
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
