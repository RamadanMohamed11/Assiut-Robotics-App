import 'package:robotics_app/helper/api.dart';

class SendOtpToEmailService {
  Future<void> sendOtpToEmail(String email) async {
    await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/members/generateOTP',
      body: {"email": email},
      token: null,
    );
  }
}
