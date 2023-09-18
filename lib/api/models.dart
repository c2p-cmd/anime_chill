class MangaSearchElement {
  final String id;
  final String title;
  final List<AltTitle> altTitles;
  final String? description;
  final Status? status;
  final int? releaseDate;
  final ContentRating? contentRating;
  final String? lastVolume;
  final String? lastChapter;

  MangaSearchElement({
    required this.id,
    required this.title,
    required this.altTitles,
    required this.description,
    required this.status,
    required this.releaseDate,
    required this.contentRating,
    required this.lastVolume,
    required this.lastChapter,
  });

  factory MangaSearchElement.fromJson(Map<String, dynamic> json) {
    return MangaSearchElement(
      id: json["id"],
      title: json["title"],
      altTitles: json["altTitles"] == null
          ? List<AltTitle>.from(
              json["altTitles"].map((x) => AltTitle.fromJson(x)))
          : [],
      description: json["description"],
      status: statusValues.map[json["status"]],
      releaseDate: json["releaseDate"],
      contentRating: contentRatingValues.map[json["contentRating"]],
      lastVolume: json["lastVolume"],
      lastChapter: json["lastChapter"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "altTitles": List<dynamic>.from(altTitles.map((x) => x.toJson())),
        "description": description,
        "status": statusValues.reverse[status],
        "releaseDate": releaseDate,
        "contentRating": contentRatingValues.reverse[contentRating],
        "lastVolume": lastVolume,
        "lastChapter": lastChapter,
      };
}

class MangaInfo {
  final String id;
  final String title;
  final List<AltTitle> altTitles;
  final Description? description;
  final List<String> genres;
  final List<String> themes;
  final String? status;
  final String releaseDate;
  final List<Chapter> chapters;
  final String image;

  MangaInfo({
    required this.id,
    required this.title,
    required this.altTitles,
    required this.description,
    required this.genres,
    required this.themes,
    required this.status,
    required this.releaseDate,
    required this.chapters,
    required this.image,
  });

  factory MangaInfo.fromJson(Map<String, dynamic> json) {
    return MangaInfo(
      id: json["id"],
      title: json["title"],
      altTitles: List<AltTitle>.from(
        json["altTitles"].map((x) => AltTitle.fromJson(x)),
      ),
      description: Description.fromJson(json["description"]),
      genres: List<String>.from(json["genres"].map((x) => x)),
      themes: List<String>.from(json["themes"].map((x) => x)),
      status: json["status"].toString(),
      releaseDate: json["releaseDate"].toString(),
      chapters:
          List<Chapter>.from(json["chapters"].map((x) => Chapter.fromJson(x))),
      image: json["image"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "altTitles": List<dynamic>.from(altTitles.map((x) => x.toJson())),
        "description": description?.toJson(),
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "themes": List<dynamic>.from(themes.map((x) => x)),
        "status": status,
        "releaseDate": releaseDate,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
        "image": image,
      };
}

class AltTitle {
  final String? ko;
  final String? en;
  final String? koRo;
  final String? jaRo;
  final String? ru;
  final String? ja;
  final String? zh;
  final String? zhHk;
  final String? la;
  final String? tr;

  AltTitle({
    required this.ko,
    required this.en,
    required this.koRo,
    required this.jaRo,
    required this.ru,
    required this.ja,
    required this.zh,
    required this.zhHk,
    required this.la,
    required this.tr,
  });

  factory AltTitle.fromJson(Map<String, dynamic> json) => AltTitle(
        ko: json["ko"],
        en: json["en"],
        koRo: json["ko-ro"],
        jaRo: json["ja-ro"],
        ru: json["ru"],
        ja: json["ja"],
        zh: json["zh"],
        zhHk: json["zh-hk"],
        la: json["la"],
        tr: json["tr"],
      );

  Map<String, dynamic> toJson() => {
        "ko": ko,
        "en": en,
        "ko-ro": koRo,
        "ja-ro": jaRo,
        "ru": ru,
        "ja": ja,
        "zh": zh,
        "zh-hk": zhHk,
        "la": la,
        "tr": tr,
      };
}

class Chapter {
  final String id;
  final String title;
  final String? chapterNumber;
  final String? volumeNumber;
  final int pages;

  Chapter({
    required this.id,
    required this.title,
    required this.chapterNumber,
    required this.volumeNumber,
    required this.pages,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json["id"],
      title: json["title"],
      chapterNumber: json["chapterNumber"],
      volumeNumber: json["volumeNumber"],
      pages: json["pages"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "chapterNumber": chapterNumber,
        "volumeNumber": volumeNumber,
        "pages": pages,
      };
}

class Description {
  final String? de;
  final String? en;
  final String? fr;
  final String? id;
  final String? it;
  final String? ja;
  final String? ko;
  final String? pl;
  final String? ru;
  final String? th;
  final String? zh;
  final String? esLa;
  final String? ptBr;
  final String? zhHk;

  Description({
    required this.de,
    required this.en,
    required this.fr,
    required this.id,
    required this.it,
    required this.ja,
    required this.ko,
    required this.pl,
    required this.ru,
    required this.th,
    required this.zh,
    required this.esLa,
    required this.ptBr,
    required this.zhHk,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        de: json["de"],
        en: json["en"],
        fr: json["fr"],
        id: json["id"],
        it: json["it"],
        ja: json["ja"],
        ko: json["ko"],
        pl: json["pl"],
        ru: json["ru"],
        th: json["th"],
        zh: json["zh"],
        esLa: json["es-la"],
        ptBr: json["pt-br"],
        zhHk: json["zh-hk"],
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "en": en,
        "fr": fr,
        "id": id,
        "it": it,
        "ja": ja,
        "ko": ko,
        "pl": pl,
        "ru": ru,
        "th": th,
        "zh": zh,
        "es-la": esLa,
        "pt-br": ptBr,
        "zh-hk": zhHk,
      };
}

class MangaPages {
  final String img;
  final int page;

  MangaPages({
    required this.img,
    required this.page,
  });

  factory MangaPages.fromJson(Map<String, dynamic> json) => MangaPages(
        img: json["img"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "page": page,
      };
}

enum ContentRating { SAFE, SUGGESTIVE }

final contentRatingValues = EnumValues(
    {"safe": ContentRating.SAFE, "suggestive": ContentRating.SUGGESTIVE});

enum Status { COMPLETED, ONGOING }

final statusValues =
    EnumValues({"completed": Status.COMPLETED, "ongoing": Status.ONGOING});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

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
      json['subOrDub'],
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
    return Episode(json['id'], json['number'].toString(), json['url']);
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
    json['episodes'].forEach((v) {
      episodesList.add(Episode.fromJson(v));
    });
    return AnimeInfo(
      animeTitle: json['title'],
      type: json['type'].toString(),
      releasedDate: json['releaseDate'],
      status: json['status'],
      genres: json['genres'].cast<String>(),
      otherNames: json['otherName'],
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
