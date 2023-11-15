

import 'package:flutter/material.dart';

class Movie extends StatelessWidget {

  int id ;
  int type_id; //type_id
  String title; //vod_name
  String subtitle; //vod_content
  String tags; // vod_tag
  String pictureURL; //vod_pic
  String actors; //vod_actor
  String director; //vod_director
  String writer; //vod_writer
  String year; //vod_year
  String rating; //vod_score
  String date; //vod_time
  String url; //vod_play_url
  bool isFavorite;

  Movie({
    required this.id,
    required this.type_id,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.pictureURL,
    required this.actors,
    required this.director,
    required this.writer,
    required this.year,
    required this.rating,
    required this.date,
    required this.url,
    this.isFavorite = false
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["vod_id"],
      type_id: json["type_id"],
      title: json["vod_name"],
      subtitle: json["vod_content"],
      tags: json["vod_tag"],
      pictureURL: json["vod_pic"],
      actors: json["vod_actor"],
      director: json["vod_director"],
      writer: json["vod_writer"],
      year: json["vod_year"],
      rating: json["vod_score"],
      date: json["vod_time"],
      url: json["vod_play_url"],
    );
  }


  String movietoString() {
    return '''
    ID: $id
    Type ID: $type_id
    Title: $title
    Subtitle: $subtitle
    Tags: $tags
    Picture URL: $pictureURL
    Actors: $actors
    Director: $director
    Writer: $writer
    Year: $year
    Rating: $rating
    Date: $date
    URL: $url
    ''';
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  } //filme, serie, animação


}
