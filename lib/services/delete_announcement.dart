import 'package:robotics_app/helper/api.dart';

class DeleteAnnouncement {
  Future<void> deleteAnnouncement(String announcementId) async {
    await API().delete(
      url:
          'https://assiut-robotics-zeta.vercel.app/announcement/$announcementId',
    );
  }
}
