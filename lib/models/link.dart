class Link {
  int? id;
  int? tmdbId;
  String? imdbId;
  String? provider;
  int? size;
  late String link;

  Link(
      {this.id,
      this.tmdbId,
      this.imdbId,
      this.provider,
      this.size,
      required this.link});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
        link: json['link'],
        id: json['id'],
        imdbId: json['imdbId'],
        tmdbId: json['tmdbId'],
        provider: json['provider'],
        size: json['size']);
  }
}
