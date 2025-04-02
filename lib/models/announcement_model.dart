class AnnouncementModel {
  final String title;
  final String content;
  final String dateOfDelete;
  final String id;

  AnnouncementModel({
    required this.title,
    required this.content,
    required this.dateOfDelete,
    required this.id,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      title: json['title'],
      content: json['content'],
      dateOfDelete: json['dateOfDelete'],
      id: json['_id'],
    );
  }
}
