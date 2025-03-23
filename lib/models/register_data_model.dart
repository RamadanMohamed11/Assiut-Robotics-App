class RegisterDataModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String committee;
  final String gender;

  RegisterDataModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.committee,
    required this.gender,
  });

  factory RegisterDataModel.fromJson(jsonData) {
    return RegisterDataModel(
      name: jsonData['name'],
      email: jsonData['email'],
      password: jsonData['password'],
      phone: jsonData['phoneNumber'],
      committee: jsonData['committee'],
      gender: jsonData['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phone,
      "committee": committee,
      "gender": gender,
    };
  }
}
