import 'package:robotics_app/helper/api.dart';

class EditAnnouncement {
  Future<void> editAnnouncement({
    required String announcementId,
    required String title,
    required String content,
    required String dateOfDelete,
    required String token,
  }) async {
    await API().put(
      url:
          'https://assiut-robotics-zeta.vercel.app/announcement/$announcementId',
      body: {'title': title, 'content': content, 'dateOfDelete': dateOfDelete},
      token: token,
    );
  }
}
