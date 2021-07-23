class YoutubeLink {
  YoutubeLink({
    this.title,
    this.link,
  });

  String title;
  String link;

  factory YoutubeLink.fromJson(Map<String, dynamic> json) => YoutubeLink(
    title: json["title"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "link": link,
  };
}