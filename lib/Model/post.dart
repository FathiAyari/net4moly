class Post {
  String owner;
  String? id;
  String? image;
  String description;
  String title;
  List<dynamic> likes;
  List<dynamic> savedFor;
  DateTime creationDate;

  Post({
    required this.owner,
    required this.savedFor,
    this.image,
    this.id,
    required this.likes,
    required this.title,
    required this.creationDate,
    required this.description,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      owner: json["owner"],
      id: json["id"],
      image: json["image"],
      title: json["title"],
      savedFor: json["savedFor"],
      description: json["description"],
      likes: json["likes"],
      creationDate: json["creationDate"].toDate(),
    );
  }
  Map<String, dynamic> Tojson() {
    return {
      "owner": owner,
      "image": image,
      "description": description,
      "creationDate": creationDate,
      "likes": likes,
      "title": title,
      "savedFor": savedFor,
    };
  }
}
