import 'package:robotics_app/helper/api.dart';

class GetComponents {
  Future<Map<String, dynamic>> getComponents() async {
    final dynamic data = await API().get(
      url: 'https://assiut-robotics-zeta.vercel.app/components/getComponents',
      token: null,
    );
    return data;
  }
}
