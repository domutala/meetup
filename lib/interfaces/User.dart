class IUser {
  int id;
  String name;
  String birthDay;
  List<String> photos;
  String? description;
  double distance;
  List<double> ages;
  String phone;

  IUser({
    required this.id,
    required this.name,
    required this.birthDay,
    required this.photos,
    this.description,
    required this.distance,
    required this.ages,
    required this.phone,
  });

  factory IUser.fromJson(Map<String, dynamic> json) {
    return new IUser(
      id: json['id'],
      name: json['name'],
      birthDay: json['birthDay'],
      photos: json['photos'],
      description: json['description'],
      distance: json['distance'],
      ages: json['ages'],
      phone: json['phone'],
    );
  }

  toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "birthDay": this.birthDay,
      "photos": this.photos,
      "description": this.description,
      "distance": this.distance,
      "ages": this.ages,
      "phone": this.phone,
    };
  }
}
