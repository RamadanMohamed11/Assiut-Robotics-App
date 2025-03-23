class ComponentModel {
  final String title;
  final String image;
  final String componentID;

  ComponentModel({
    required this.title,
    required this.image,
    required this.componentID,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      title: json["title"],
      image: json["image"] ?? "assets/images/Rob.png",
      componentID: json["_id"],
    );
  }
}
