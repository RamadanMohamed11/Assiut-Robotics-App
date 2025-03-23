import 'package:robotics_app/helper/api.dart';

class RequestToBorrow {
  Future<Map<String, dynamic>> requestToBorrow({
    required String token,
    required String componentId,
  }) async {
    final dynamic data = await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/components/requestToBorrow',
      body: {"componentId": componentId},
      token: token,
    );
    return data;
  }
}
