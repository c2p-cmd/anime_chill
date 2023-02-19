Uri searchAnime(String animeName) => Uri.parse('https://gogoanime.consumet.stream/search?keyw=$animeName');

Uri animeDetails(String animeId) => Uri.parse('https://gogoanime.consumet.stream/anime-details/$animeId');

Uri animeEpisodes(String episodeId) => Uri.parse("https://gogoanime.consumet.stream/vidcdn/watch/$episodeId");