import 'package:robotics_app/helper/api.dart';

class GetHistoryComponent {
  Future<Map<String, dynamic>> getHistoryComponent(String token) async {
    final dynamic data = await API().get(
      url:
          'https://assiut-robotics-zeta.vercel.app/components/getHistoryComponent',
      token: token,
    );
    return data;
  }
}
