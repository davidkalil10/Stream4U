import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistItem {
  String title;
  String logoUrl;
  String url;
  String category;

  PlaylistItem(this.title, this.logoUrl, this.url, this.category);

  // Método para converter PlaylistItem para Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'logoUrl': logoUrl,
      'url': url,
      'category': category,
    };
  }

  // Método para criar PlaylistItem a partir de um Map
  factory PlaylistItem.fromMap(String mapString) {
    final map = Map<String, dynamic>.from(json.decode(mapString));
    return PlaylistItem(
      map['title'],
      map['logoUrl'],
      map['url'],
      map['category'],
    );
  }

}

Future<List<PlaylistItem>> parseM3U(String content) async {
  List<PlaylistItem> playlist = [];

  // Divide o conteúdo por linhas
  List<String> lines = content.split('\n');

  String? currentTitle;
  String? currentLogoUrl;
  String? currentCategory;
  String? currentID;

  for (String line in lines) {
    line = line.trim();

    if (line.startsWith('#EXTINF:-1')) {
      //print(line);
      // Se a linha começar com '#EXTINF:', extrai o título, o URL da imagem e o tvg-id
      RegExp extInfRegex = new RegExp(r'^#EXTINF:(-?\d+) tvg-id="(.*)" tvg-name="(.*)" tvg-logo="(.*)" group-title="(.*)"');
      RegExpMatch? match2 = extInfRegex.firstMatch(line);
      //print(match2!.group(2)!.toString());
      if (match2 != null) {

        currentTitle = match2!.group(3) == null ? "":match2.group(3);
        currentLogoUrl = match2!.group(4)!.split('"')[0] == null ? "": match2!.group(4)!.split('"')[0];
        currentCategory = match2.group(5) == null ? "":match2.group(5);
        currentID = match2!.group(2) == null ? "":match2.group(2);

        //Verificar se a URL da logo não é invalida
          String newURL = await _checkImageURL(currentLogoUrl);
          currentLogoUrl = newURL;
        // Verifica se o tvg-id não é vazio
        if (currentID!.isNotEmpty) {
          playlist.add(PlaylistItem(currentTitle ?? '', currentLogoUrl ?? '', '', currentCategory!));
        }
      }
    } else if (line.startsWith('http') && currentID != null && currentID.isNotEmpty) {
    //  print(line);
      // Se a linha começar com 'http' e o tvg-id não for vazio, é uma URL de mídia
      playlist.last.url = line == null ? "": line; // Adiciona a URL à última entrada da lista
    }
  }

  return playlist;
}

Future<String> _checkImageURL(String imageUrl) async {
  if (imageUrl.startsWith("s:1:/") == true){
    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn2PaU23IXq4EetGvnU_vClODAtTJrjLJ0KA&usqp=CAU";
  }else{
    return imageUrl;
  }
}

