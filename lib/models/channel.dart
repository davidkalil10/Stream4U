import 'package:flutter/material.dart';
import 'package:stream4u/models/PlaylistItem.dart';

class Channel extends StatelessWidget {

  String title; //vod_name
  String category; //vod_content
  String pictureURL; //vod_pic
  String url; //vod_play_url

  Channel({
    required this.title,
    required this.category,
    required this.pictureURL,
    required this.url,
  });


  String channeltoString() {
    return '''
    Title: $title
    Category: $category
    Picture URL: $pictureURL
    URL: $url
    ''';
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static Channel fromPlaylist(PlaylistItem content) {
    return Channel(title: content.title, category: content.category, pictureURL: content.logoUrl, url: content.url);
  } //filme, serie, animação


}
