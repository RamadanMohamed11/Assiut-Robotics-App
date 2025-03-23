class RequestedComponentModel {
  final String title;
  final String image;
  final String componentID;
  final String memberName;
  final String memberPhoneNumber;
  final String memberImage;
  final String memberCommittee;

  RequestedComponentModel({
    required this.title,
    required this.image,
    required this.componentID,
    required this.memberName,
    required this.memberPhoneNumber,
    required this.memberImage,
    required this.memberCommittee,
  });

  factory RequestedComponentModel.fromJson(Map<String, dynamic> json) {
    return RequestedComponentModel(
      title: json["title"],
      image: json["image"] ?? "assets/images/Rob.png",
      componentID: json["_id"],
      memberName: json["requestToBorrow"]["name"],
      memberPhoneNumber: json["requestToBorrow"]["phoneNumber"],
      memberImage: json["requestToBorrow"]["avatar"],
      memberCommittee: json["requestToBorrow"]["committee"],
    );
  }
}
