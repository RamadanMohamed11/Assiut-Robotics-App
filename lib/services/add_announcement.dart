import 'package:robotics_app/helper/api.dart';

class AddAnnouncement {
  Future<Map<String, dynamic>> addAnnouncement({
    required String title,
    required String content,
    required String dateOfDelete,
  }) async {
    final dynamic data = await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/announcement/add',
      body: {'title': title, 'content': content, 'dateOfDelete': dateOfDelete},
    );
    return data;
  }
}
