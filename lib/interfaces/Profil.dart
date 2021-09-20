class IProfil {
  String name;
  int age;
  List<String> photos;
  String? description;
  String? position;

  IProfil({
    required this.name,
    required this.age,
    required this.photos,
    this.description,
    this.position,
  });

  IProfil._({
    required this.name,
    required this.age,
    required this.photos,
    this.description,
    this.position,
  });

  factory IProfil.fromJson(Map<String, dynamic> json) {
    return new IProfil._(
      name: json['name'],
      age: json['age'],
      photos: json['photos'],
      description: json['description'],
      position: json['position'],
    );
  }
}
