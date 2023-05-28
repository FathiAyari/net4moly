class Cours {
  String owner;
  String? id;
  String? file;
  String description;
  int categoryId;
  String title;
  List<dynamic> likes;
  List<dynamic> savedFor;
  DateTime creationDate;

  Cours({
    required this.owner,
    required this.categoryId,
    required this.savedFor,
    this.file,
    this.id,
    required this.likes,
    required this.title,
    required this.creationDate,
    required this.description,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      owner: json["owner"],
      id: json["id"],
      categoryId: json["categoryId"],
      file: json["file"],
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
      "file": file,
      "description": description,
      "creationDate": creationDate,
      "likes": likes,
      "title": title,
      "savedFor": savedFor,
      "categoryId": categoryId,
    };
  }
}
