import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChannelCard extends StatelessWidget {


  final String urlPic;
  final String title;
  final String category;
  final String url;


  ChannelCard({
    required this.urlPic,
    required this.title,
    required this.category,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: urlPic,
                ),
              ),
            ),
            height: 250,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Color(0xFF1C1C1C),
                  boxShadow:   [BoxShadow(
                    color: Color(0xFF101010),
                    spreadRadius: 5,
                    blurRadius: 30,
                    offset: Offset(0, 3),
                  )],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(title,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0xFF101010),
                                        spreadRadius: 5,
                                        blurRadius: 30,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.white
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
