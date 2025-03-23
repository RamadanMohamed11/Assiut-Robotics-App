import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/home_page.dart';
import 'package:robotics_app/pages/home_page_after_login.dart';
import 'package:robotics_app/pages/requested_components_page.dart';
import 'package:robotics_app/pages/waiting_page_at_first.dart';
import 'package:robotics_app/services/is_verified_account.dart';
import 'package:robotics_app/services/login_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userData'); // Open a box to store theme mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final box = Hive.box('userData');
  late ProfileModel profileModel;

  Future<bool> initializeApp() async {
    try {
      // Check if the token exists
      String userToken = box.get("token", defaultValue: "");
      if (userToken == "") {
        print("No token found in Hive box.");
        return false;
      }

      // Check if the account is verified
      final isVerified = await IsVerifiedAccount().isVerifiedAccount(
        box.get("email", defaultValue: ""),
        userToken,
      );

      if (isVerified) {
        print("Account is verified. Logging in...");
        // Initialize the profileModel if the account is verified
        dynamic data = await LoginService().login(
          email: box.get("email"),
          password: box.get("password"),
        );

        // Debug: Print the response data
        print("Login response: $data");

        // Check if the response contains the expected keys
        if (data != null &&
            data["data"] != null &&
            data["data"]["memberData"] != null) {
          // Parse the profile model
          profileModel = ProfileModel.fromJson(data["data"]);
          print("Profile model initialized: ${profileModel.toString()}");
        } else {
          print("Error: memberData is null or missing in the response.");
          return false; // Return false to show the error page
        }
      } else {
        print("Account is not verified.");
      }

      return isVerified;
    } catch (e, stackTrace) {
      // Log the error and stack trace
      print("Error in initializeApp: $e");
      print(stackTrace);
      return false; // Return false to show the error page
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initializeApp(), // Use the combined Future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ScreenUtilInit(
            builder: (_, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: WaitingPageAtFirst(),
              );
            },
          );
        } else if (snapshot.hasError) {
          // Log the error
          print("FutureBuilder error: ${snapshot.error}");
          return ScreenUtilInit(
            builder: (_, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(body: Center(child: Text("Error occurred"))),
              );
            },
          );
        } else {
          if (snapshot.data!) {
            return ScreenUtilInit(
              builder: (_, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: HomePageAfterLogin(profileModel: profileModel),
                  // home: RequestedComponentsPage(),
                );
              },
            );
          } else {
            return ScreenUtilInit(
              builder: (_, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: HomePage(),
                );
              },
            );
          }
        }
      },
    );
  }
}
