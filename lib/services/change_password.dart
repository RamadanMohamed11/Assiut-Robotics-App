import 'package:robotics_app/helper/api.dart';

class ChangePassword {
  Future<void> changePassword({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/members/changePassword',
      body: {"email": email, "code": code, "newPassword": newPassword},
      token: null,
    );
  }
}
