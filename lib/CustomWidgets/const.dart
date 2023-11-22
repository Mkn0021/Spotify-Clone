import 'package:flutter/material.dart';

class PlayListItem {
  String img;
  String title;
  String? creator;
  PlayListItem({required this.title, required this.img, this.creator});
}

List<PlayListItem> kPlaylistPodcast = [
  PlayListItem(
    title: 'Supercars and cities',
    img: 'assets/cover/genre_img_ambient.jpg',
    creator: 'Show • Urban racer',
  ),
  PlayListItem(
    title: 'Best barn finds',
    img: 'assets/cover/genre_img_electronic.jpg',
    creator: 'Show • Car finder',
  ),
  PlayListItem(
    title: 'Life at the red line',
    img: 'assets/cover/genre_img_classical.jpeg',
    creator: 'Show • Speedometer',
  ),
];

List<PlayListItem> kPlaylistForYou = [
  PlayListItem(
    title: 'Current favorites and exciting new music. Cover: Charlie Puth',
    img: 'assets/cover/genre_img_sleep.jpeg',
  ),
  PlayListItem(
    title: "Viral classics. Yep, we're at that stage.",
    img: 'assets/cover/genre_img_rock.jpg',
  ),
  PlayListItem(
    title: 'A mega mix of 75 favorites from the last few years!',
    img: 'assets/cover/genre_img_metal.jpeg',
  ),
];

class SearchListItem {
  String img;
  String title;
  Color color;
  SearchListItem({required this.title, required this.img, required this.color});
}

List<SearchListItem> kPlaylistSdded = [
  SearchListItem(
    title: 'Rock',
    img: 'assets/cover/genre_img_rock.jpg',
    color: Colors.deepPurple,
  ),
  SearchListItem(
    title: 'Sleep',
    img: 'assets/cover/genre_img_sleep.jpeg',
    color: Colors.teal,
  ),
  SearchListItem(
    title: 'Pop',
    img: 'assets/cover/genre_img_pop.jpg',
    color: Colors.orange,
  ),
  SearchListItem(
    title: 'Piano',
    img: 'assets/cover/genre_img_piano.jpg',
    color: Colors.indigo,
  ),
  SearchListItem(
    title: 'Metal',
    img: 'assets/cover/genre_img_metal.jpeg',
    color: Colors.redAccent,
  ),
  SearchListItem(
    title: 'Dance',
    img: 'assets/cover/genre_img_dance.jpg',
    color: Colors.pink,
  ),
];

List<SearchListItem> kAllSearh = [
  SearchListItem(
    title: 'Rock',
    img: 'assets/cover/genre_img_rock.jpg',
    color: Colors.deepPurple,
  ),
  SearchListItem(
    title: 'Sleep',
    img: 'assets/cover/genre_img_sleep.jpeg',
    color: Colors.teal,
  ),
  SearchListItem(
    title: 'Pop',
    img: 'assets/cover/genre_img_pop.jpg',
    color: Colors.orange,
  ),
  SearchListItem(
    title: 'Piano',
    img: 'assets/cover/genre_img_piano.jpg',
    color: Colors.indigo,
  ),
  SearchListItem(
    title: 'Metal',
    img: 'assets/cover/genre_img_metal.jpeg',
    color: Colors.redAccent,
  ),
  SearchListItem(
    title: 'Dance',
    img: 'assets/cover/genre_img_dance.jpg',
    color: Colors.pink,
  ),
  SearchListItem(
    title: 'Ambient',
    img: 'assets/cover/genre_img_ambient.jpg',
    color: Colors.lightBlue,
  ),
  SearchListItem(
    title: 'Trending',
    img: 'assets/cover/genre_img_chill.jpeg',
    color: Colors.amber,
  ),
  SearchListItem(
    title: 'Sleep',
    img: 'assets/cover/genre_img_sleep.jpeg',
    color: Colors.deepOrange,
  ),
  SearchListItem(
    title: 'Soulful',
    img: 'assets/cover/genre_img_piano.jpg',
    color: Colors.green,
  ),
];


class FilterItem {
  String title;
  Function()? onTap;
  FilterItem({
    required this.title,
    this.onTap,
  });
}

List<FilterItem> kFilters = [
  FilterItem(
    title: 'Playlist',
  ),
  FilterItem(
    title: 'Artist',
  ),
];
