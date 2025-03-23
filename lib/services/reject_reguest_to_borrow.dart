import 'package:robotics_app/helper/api.dart';

class RejectReguestToBorrow {
  Future<bool> rejectReguestToBorrow(String token, String componentId) async {
    final dynamic data = await API().post(
      url:
          'https://assiut-robotics-zeta.vercel.app/components/rejectRequestToBorrow',
      body: {"componentId": componentId},
      token: token,
    );
    return data["message"] == "rejected";
  }
}
