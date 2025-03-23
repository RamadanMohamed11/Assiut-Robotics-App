class ProfileModel {
  final String name;
  final String email;
  final String committee;
  final String role;
  final String phoneNumber;
  final bool verified;
  final String profileImage;
  final String token;

  ProfileModel({
    required this.name,
    required this.email,
    required this.committee,
    required this.role,
    required this.phoneNumber,
    required this.verified,
    required this.profileImage,
    required this.token,
  });

  factory ProfileModel.fromJson(jsonData) {
    return ProfileModel(
      name: jsonData["memberData"]['name'],
      email: jsonData["memberData"]['email'],
      committee: jsonData["memberData"]['committee'],
      role: jsonData["memberData"]['role'],
      phoneNumber: jsonData["memberData"]['phoneNumber'],
      verified: jsonData["memberData"]['verified'],
      profileImage: jsonData["memberData"]['avatar'],
      token: jsonData['token'],
    );
  }
}
