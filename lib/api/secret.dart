const baseUrl = 'https://api.consumet.org/anime';
const mine = 'https://webdis-z7xm.onrender.com';
const gogoAnime = '$baseUrl/gogoanime';

Uri searchAnime(String animeName, [String baseUrl = gogoAnime]) =>
    Uri.parse('$baseUrl/$animeName');

Uri animeDetails(String animeId, [String baseUrl = gogoAnime]) =>
    Uri.parse('$baseUrl/info/$animeId');

Uri animeEpisodes(String episodeId, [String baseUrl = gogoAnime]) =>
    Uri.parse("$baseUrl/watch/$episodeId");
// https://api.consumet.org/anime/gogoanime/watch/{episodeId}?server={serverName}

Uri popularAnime([String baseUrl = gogoAnime]) => Uri.parse('$baseUrl/top-airing');

Uri mangaDexSearch(String arguments) => Uri.parse("https://api.consumet.org/manga/mangadex/$arguments");

Uri mangaDexGetInfo(String mangaId) => Uri.parse("https://api.consumet.org/manga/mangadex/info/$mangaId");

Uri mangaDexRead(String chapterId) => Uri.parse("https://api.consumet.org/manga/mangadex/read/$chapterId");

String defaultBaseUrl = gogoAnime;
