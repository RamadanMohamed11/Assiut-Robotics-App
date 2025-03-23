import 'package:robotics_app/helper/api.dart';

class GetBorrowedComponent {
  Future<Map<String, dynamic>> getBorrowedComponent({
    required String token,
  }) async {
    final dynamic data = await API().get(
      url:
          'https://assiut-robotics-zeta.vercel.app/components/getBorrowedComponent',
      token: token,
    );
    return data;
  }
}
