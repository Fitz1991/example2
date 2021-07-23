
class Story {
  Story({
    this.title,
    this.description,
    this.photo,
  });

  String title = '';
  String description = '';
  String photo = '';

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    title: json["title"] ?? '',
    description: json["description"] ?? '' ,
    photo: json["photo"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "photo": photo,
  };

  bool isEmpty()
  {
    if(this.title.isEmpty && this.description.isEmpty && this.photo.isEmpty) return true;
    else return false;
  }
}