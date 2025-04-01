class ComponentModel {
  final String title;
  final int price;
  final String category;
  final String image;
  final String componentID;

  ComponentModel({
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.componentID,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      title: json["title"],
      price: json["price"],
      category: json["category"],
      image: json["image"] ?? "assets/images/Rob.png",
      componentID: json["_id"],
    );
  }
}
