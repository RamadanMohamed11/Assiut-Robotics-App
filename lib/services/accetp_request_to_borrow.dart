import 'package:robotics_app/helper/api.dart';

class AccetpRequestToBorrow {
  Future<void> accetpRequestToBorrow({
    required String token,
    required String componentId,
    required String borrowDate,
    required String deadlineDate,
  }) async {
    await API().post(
      url:
          'https://assiut-robotics-zeta.vercel.app/components/acceptRequestToBorrow',
      body: {
        "componentId": componentId,
        "borrowDate": borrowDate,
        "deadlineDate": deadlineDate,
      },
      token: token,
    );
  }
}
