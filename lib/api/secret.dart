const _baseUrl = 'https://consumet-api-snowy.vercel.app';
// const mine = 'https://webdis-z7xm.onrender.com';
const gogoAnime = '$_baseUrl/anime/gogoanime';
const flixhq = '$_baseUrl/movies/flixhq';

Uri searchAnime(String animeName, [String baseUrl = gogoAnime]) =>
    Uri.parse('$baseUrl/$animeName');

Uri animeDetails(
  String animeId, {
  bool showAnimeSearch = true,
}) {
  final baseUrl = showAnimeSearch ? gogoAnime : flixhq;
  if (showAnimeSearch) return Uri.parse('$baseUrl/info/$animeId');
  return Uri.parse('$baseUrl/info?id=$animeId');
}

Uri animeEpisodes(String episodeId,
    {String baseUrl = gogoAnime, String mediaId = ''}) {
  if (baseUrl == flixhq) {
    return Uri.parse("$baseUrl/watch?episodeId=$episodeId&mediaId=$mediaId");
  }
  return Uri.parse("$baseUrl/watch/$episodeId");
}
// https://api.consumet.org/anime/gogoanime/watch/{episodeId}?server={serverName}

Uri popularAnime({String baseUrl = gogoAnime}) => (baseUrl == flixhq)
    ? Uri.parse('$baseUrl/trending')
    : Uri.parse('$baseUrl/top-airing');
