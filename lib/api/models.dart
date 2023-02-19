class AnimeSearchResult {
  final String id, title, url, img, status;

  AnimeSearchResult(this.id, this.title, this.url, this.img, this.status);

  factory AnimeSearchResult.fromJson(Map<String, dynamic> json) {
    return AnimeSearchResult(
      json['animeId'],
      json['animeTitle'],
      json['animeUrl'],
      json['animeImg'],
      json['status'],
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
    return Episode(json['episodeId'], json['episodeNum'], json['episodeUrl']);
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

  AnimeInfo(
      {required this.animeTitle,
      required this.type,
      required this.releasedDate,
      required this.status,
      required this.genres,
      required this.otherNames,
      required this.synopsis,
      required this.animeImg,
      required this.totalEpisodes,
      required this.episodesList});

  factory AnimeInfo.fromJson(Map<String, dynamic> json) {
    final episodesList = <Episode>[];
    json['episodesList'].forEach((v) {
      episodesList.add(Episode.fromJson(v));
    });
    return AnimeInfo(
      animeTitle: json['animeTitle'],
      type: json['type'],
      releasedDate: json['releasedDate'],
      status: json['status'],
      genres: json['genres'].cast<String>(),
      otherNames: json['otherNames'],
      synopsis: json['synopsis'],
      animeImg: json['animeImg'],
      totalEpisodes: json['totalEpisodes'],
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
  final String referer;
  final List<EpisodeLinkSources> sources;

  EpisodeLinks(this.referer, this.sources);

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
    return EpisodeLinks(json['Referer'], sources);
  }

  @override
  String toString() {
    return 'EpisodeLinks{referer: $referer, sources: $sources}';
  }
}

class EpisodeLinkSources {
  final String file, label, type;

  EpisodeLinkSources(this.file, this.label, this.type);

  factory EpisodeLinkSources.fromJson(Map<String, dynamic> json) {
    return EpisodeLinkSources(json['file'], json['label'], json['type']);
  }

  @override
  String toString() {
    return 'EpisodeLinkSources{file: $file, label: $label, type: $type}';
  }
}