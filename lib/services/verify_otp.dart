import 'package:robotics_app/helper/api.dart';

class VerifyOtp {
  Future<void> verifyOtp({required String email, required String otp}) async {
    await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/members/verifyOTP',
      body: {"email": email, "code": otp},
      token: null,
    );
  }
}
