class AddComponentModel {
  final String title;
  final String price;
  final String count;
  final String location;
  final String category;
  AddComponentModel({
    required this.title,
    required this.price,
    required this.count,
    required this.location,
    required this.category,
  });

  factory AddComponentModel.fromJson(Map<String, dynamic> json) {
    return AddComponentModel(
      title: json['title'],
      price: json['price'],
      count: json['count'],
      location: json['location'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
    'count': count,
    'location': location,
    'category': category,
  };
}
