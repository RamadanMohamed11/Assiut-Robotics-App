import 'package:robotics_app/helper/api.dart';

class IsVerifiedAccount {
  Future<bool> isVerifiedAccount(String email, String token) async {
    final dynamic data = await API().get(
      url: "https://assiut-robotics-zeta.vercel.app/members/verify",
      token: token,
    );
    print(data["message"]);
    return data["message"] == "success authorization";
  }
}
