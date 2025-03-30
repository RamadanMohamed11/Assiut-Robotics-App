import 'package:robotics_app/helper/api.dart';

class DeleteOneComponent {
  Future<Map<String, dynamic>> deleteOneComponent({
    required String token,
    required String componentId,
  }) async {
    final dynamic data = await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/components/deleteOne',
      body: {"id": componentId},
      token: token,
    );
    print(data);
    return data;
  }
}
