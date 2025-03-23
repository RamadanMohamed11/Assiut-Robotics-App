import 'package:robotics_app/helper/api.dart';

class GetRequestedComponent {
  Future<Map<String, dynamic>> getRequestedComponent(String token) async {
    final dynamic data = await API().get(
      url:
          'https://assiut-robotics-zeta.vercel.app/components/getRequestedComponent',
      token: token,
    );
    return data;
  }
}
