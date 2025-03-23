import 'package:robotics_app/helper/api.dart';
import 'package:robotics_app/models/register_data_model.dart';

class RegisterService {
  Future<String> register(RegisterDataModel registerData) async {
    dynamic data = await API().post(
      url: 'https://assiut-robotics-zeta.vercel.app/members/register',
      body: {
        "email": registerData.email,
        "password": registerData.password,
        "name": registerData.name,
        "phoneNumber": registerData.phone,
        "committee": registerData.committee,
        "gender": registerData.gender,
      },
      token: null,
    );
    return data['message'];
  }
}
