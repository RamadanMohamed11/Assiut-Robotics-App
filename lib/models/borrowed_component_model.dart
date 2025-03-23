class BorrowedComponentModel {
  final String title;
  final String image;
  final String componentID;
  final String memberName;
  final String memberPhoneNumber;
  final String memberImage;
  final String memberCommittee;
  final String borrowDate;
  final String deadlineDate;

  BorrowedComponentModel({
    required this.title,
    required this.image,
    required this.componentID,
    required this.memberName,
    required this.memberPhoneNumber,
    required this.memberImage,
    required this.memberCommittee,
    required this.borrowDate,
    required this.deadlineDate,
  });

  factory BorrowedComponentModel.fromJson(Map<String, dynamic> json) {
    return BorrowedComponentModel(
      title: json['title'],
      image: json['image'] ?? "assets/images/Rob.png",
      componentID: json['_id'],
      memberName: json["borrowedBy"]["member"]['name'],
      memberPhoneNumber: json["borrowedBy"]["member"]['phoneNumber'],
      memberImage: json["borrowedBy"]["member"]['avatar'],
      memberCommittee: json["borrowedBy"]["member"]['committee'],
      borrowDate: json["borrowedBy"]['borrowDate'],
      deadlineDate: json["borrowedBy"]['deadlineDate'],
    );
  }
}
