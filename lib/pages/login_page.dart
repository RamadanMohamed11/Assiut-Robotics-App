import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/forget_password_email.dart';
import 'package:robotics_app/pages/home_page_after_login.dart';
import 'package:robotics_app/services/login_service.dart';
import 'package:robotics_app/widgets/login_signup_button.dart';
import 'package:robotics_app/widgets/moving_logo.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;

  // TextField controller
  bool isObscureText = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true); // Repeat the animation in reverse

    _animation = Tween<double>(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Listen to animation status changes
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.reverse) {
        await _audioPlayer.stop();
      }
      if (status == AnimationStatus.forward) {
        if (isLoading == true) {
          await _audioPlayer.setVolume(1.2);
          await _audioPlayer.setPlaybackRate(1); // Increase speed (1.5x faster)
          await _audioPlayer.play(AssetSource('sounds/peo.mp3'));
        }
      }
    });
  }

  void loginOnTap() async {
    setState(() {
      isLoading = true; // Show loading state if needed
    });
    try {
      dynamic data = await LoginService().login(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) {
        return;
      } // Ensure the widget is still in the tree
      ProfileModel profile = ProfileModel.fromJson(data["data"]);

      if (!mounted) return; // Check again before using context

      final box = Hive.box('userData');
      box.put("email", emailController.text);
      box.put("password", passwordController.text);
      box.put("token", data["data"]["token"]);

      Navigator.pushAndRemoveUntil(
        context,
        CustomScaleTransition(
          HomePageAfterLogin(profileModel: profile),
          alignment: Alignment.center,
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessageDialog(
        context,
        false,
        false,
        e.toString().replaceFirst('Exception: ', ''),
        btnOkOnPress: () {},
      );
      // showDialog(
      //   context: context,
      //   builder:
      //       (context) => AlertDialog(
      //         backgroundColor: kPrimarycolor1,
      //         title: Text(
      //           "Error",
      //           style: TextStyle(
      //             color: Colors.red,
      //             fontSize: 24.sp,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         content: Text(
      //           e.toString().replaceFirst('Exception: ', ''),
      //           style: TextStyle(color: Colors.white, fontSize: 22.sp),
      //         ),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: Text(
      //               "OK",
      //               style: TextStyle(color: Colors.white, fontSize: 20.sp),
      //             ),
      //           ),
      //         ],
      //       ),
      // );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading == true
              ? MovingLogo(
                animationController: _animationController,
                animation: _animation,
              )
              : Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kPrimarycolor1, kPrimarycolor2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(45.0.sp),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 45.h),
                                StaticLogo(),
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "InkBrushArabic",
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: "InkBrushArabic",
                                      fontSize: 24.sp,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                TextField(
                                  obscureText: isObscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isObscureText = !isObscureText;
                                        });
                                      },
                                      icon: Icon(
                                        isObscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "InkBrushArabic",
                                      fontSize: 24.sp,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                CustomButton(
                                  loginOnTap: loginOnTap,
                                  text: "Log in",
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CustomScaleTransition(
                                        ForgetPasswordEmail(),
                                        alignment: Alignment.bottomCenter,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "forgot your password",
                                    style: TextStyle(
                                      fontFamily: "InkBrushArabic",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 21.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
