import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const mine = 'https://webdis-z7xm.onrender.com';
const gogoAnime = 'https://gogoanime.consumet.stream';

Uri searchAnime(String animeName, [String baseUrl = gogoAnime]) =>
    Uri.parse('$baseUrl/search?keyw=$animeName');

Uri animeDetails(String animeId, [String baseUrl = gogoAnime]) =>
    Uri.parse('$baseUrl/anime-details/$animeId');

Uri animeEpisodes(String episodeId, [String baseUrl = gogoAnime]) =>
    Uri.parse("$baseUrl/vidcdn/watch/$episodeId");

Uri popularAnime([String baseUrl = gogoAnime]) => Uri.parse('$baseUrl/popular');

String defaultBaseUrl = gogoAnime;

const urlWidgets = [
  DropdownMenuItem(
    value: gogoAnime,
    child: Text("GogoAnime"),
  ),
  DropdownMenuItem(
    value: mine,
    child: Text('Mine'),
  ),
];
