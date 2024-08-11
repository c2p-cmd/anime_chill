class AnimePopular {
  final String id, title, url, img;

  AnimePopular(this.id, this.title, this.url, this.img);

  factory AnimePopular.fromJson(Map<String, dynamic> json) {
    return AnimePopular(
      json['id'],
      json['title'],
      json['url'],
      json['image'],
    );
  }

  @override
  String toString() {
    return 'AnimePopular{id: $id, title: $title}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimePopular &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

class AnimeSearchResult {
  final String id, title, url, img, status;

  AnimeSearchResult(this.id, this.title, this.url, this.img, this.status);

  factory AnimeSearchResult.fromJson(Map<String, dynamic> json) {
    return AnimeSearchResult(
      json['id'],
      json['title'],
      json['url'],
      json['image'],
      json['subOrDub'] ?? json['type'],
    );
  }

  @override
  String toString() {
    return 'AnimeSearchResult{id: $id, title: $title}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

class Episode {
  final String id, num, url;

  Episode(this.id, this.num, this.url);

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        json['id'], (json['title'] ?? json['number']).toString(), json['url']);
  }

  @override
  String toString() {
    return 'Episode{id: $id, num: $num, url: $url}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Episode &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          num == other.num;

  @override
  int get hashCode => id.hashCode ^ num.hashCode;
}

class AnimeInfo {
  final String id;
  final String animeTitle;
  final String type;
  final String releasedDate;
  final String status;
  final List<String> genres;
  final String otherNames;
  final String synopsis;
  final String animeImg;
  final String totalEpisodes;
  final List<Episode> episodesList;

  AnimeInfo({
    required this.id,
    required this.animeTitle,
    required this.type,
    required this.releasedDate,
    required this.status,
    required this.genres,
    required this.otherNames,
    required this.synopsis,
    required this.animeImg,
    required this.totalEpisodes,
    required this.episodesList,
  });

  factory AnimeInfo.fromJson(Map<String, dynamic> json) {
    final episodesList = <Episode>[];
    json['episodes'].forEach((v) {
      episodesList.add(Episode.fromJson(v));
    });
    return AnimeInfo(
      id: json['id'],
      animeTitle: json['title'],
      type: json['type'].toString(),
      releasedDate: json['releaseDate'],
      status: json['status'] ?? 'Completed',
      genres: json['genres'].cast<String>(),
      otherNames: json['otherName'] ?? '',
      synopsis: json['description'],
      animeImg: json['image'],
      totalEpisodes: json['totalEpisodes'].toString(),
      episodesList: episodesList,
    );
  }

  @override
  String toString() {
    return 'AnimeInfo{animeTitle: $animeTitle, releasedDate: $releasedDate, genres: $genres}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeInfo &&
          runtimeType == other.runtimeType &&
          animeTitle == other.animeTitle &&
          releasedDate == other.releasedDate &&
          otherNames == other.otherNames;

  @override
  int get hashCode =>
      animeTitle.hashCode ^ releasedDate.hashCode ^ otherNames.hashCode;
}

class EpisodeLinks {
  final List<EpisodeLinkSources> sources;

  EpisodeLinks(this.sources);

  factory EpisodeLinks.fromJson(Map<String, dynamic> json) {
    final sources = <EpisodeLinkSources>[];
    final List<dynamic> sourcesList = json['sources'];
    for (var element in sourcesList) {
      sources.add(EpisodeLinkSources.fromJson(element));
    }
    if (json['sources_bk'] != null) {
      final List<dynamic> sourcesListBk = json['sources_bk'];
      for (var element in sourcesListBk) {
        sources.add(EpisodeLinkSources.fromJson(element));
      }
    }
    return EpisodeLinks(sources);
  }

  @override
  String toString() {
    return 'EpisodeLinks{sources: $sources}';
  }
}

class EpisodeLinkSources {
  final String url, quality;

  EpisodeLinkSources(this.url, this.quality);

  factory EpisodeLinkSources.fromJson(Map<String, dynamic> json) {
    return EpisodeLinkSources(json['url'], json['quality']);
  }

  @override
  String toString() {
    return 'EpisodeLinkSources{url: $url, quality: $quality';
  }
}
