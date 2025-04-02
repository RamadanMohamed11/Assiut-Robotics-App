import 'package:robotics_app/helper/api.dart';
import 'package:robotics_app/models/announcement_model.dart';

class GetAnnouncement {
  Future<List<AnnouncementModel>> getAnnouncement({
    required String committee,
  }) async {
    final dynamic data = await API().get(
      url:
          'https://assiut-robotics-zeta.vercel.app/announcement/getAnnouncements',
    );

    List<AnnouncementModel> announcementModels = [];

    for (int i = 0; i < data["data"].length; i++) {
      if (data["data"][i]["creator"]["committee"] == committee ||
          data["data"][i]["creator"]["committee"] == "manager") {
        announcementModels.add(AnnouncementModel.fromJson(data["data"][i]));
      }
    }

    return announcementModels;
  }
}
