import 'package:robotics_app/helper/api.dart';

class ReturnComponent {
  Future<bool> returnComponent({
    required String token,
    required String componentId,
  }) async {
    dynamic data = await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/components/return',
      body: {"componentId": componentId},
      token: token,
    );
    return data["message"] == "returned";
  }
}
