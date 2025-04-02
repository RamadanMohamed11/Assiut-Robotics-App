import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/register_data_model.dart';
import 'package:robotics_app/pages/login_page.dart';
import 'package:robotics_app/services/register_service.dart';
import 'package:robotics_app/widgets/login_signup_button.dart';
import 'package:robotics_app/widgets/moving_logo.dart';
import 'package:robotics_app/widgets/static_logo.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  // Animation controller
  late AnimationController _animationController;

  late Animation<double> _animation;

  late AudioPlayer _audioPlayer;

  // TextField controller
  bool isObscureText = true;

  final List gender = ["Male", "Female"];

  String selectedGender = "Male";
  late String selectedCommittee;

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

  void registerOnTap() async {
    setState(() {
      isLoading = true; // Show loading state if needed
    });
    try {
      RegisterDataModel registerData = RegisterDataModel(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneNumberController.text,
        committee: selectedCommittee,
        gender: selectedGender,
      );
      String message = await RegisterService().register(registerData);
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        showMessageDialog(
          context,
          true,
          false,
          message,
          btnOkOnPress: () {
            Navigator.push(
              context,
              CustomSizeTransition(
                LoginPage(),
                alignment: Alignment.centerLeft,
              ),
            );
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => LoginPage()),
            // );
          },
        );
      }
      // if (!mounted) {
      //   return;
      // } // Ensure the widget is still in the tree

      // if (!mounted) {
      //   return;
      // } // Check again before using context

      // // final box = Hive.box('userData');
      // // box.put("email", emailController.text);
      // // box.put("password", passwordController.text);
      // // box.put("token", data["data"]["token"]);

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kPrimarycolor1, kPrimarycolor2],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 45.w,
                            vertical: 1.h,
                          ),
                          child: SizedBox(
                            child: Column(
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
                                  controller: nameController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Name",
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
                                  controller: emailController,

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
                                SizedBox(height: 20.h),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Select Committee",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.sp,
                                        fontFamilyFallback: ["InkBrushArabic"],
                                      ),
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
                                  dropdownColor: kPrimarycolor1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "InkBrushArabic",
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  items:
                                      [
                                        "HR",
                                        "PR",
                                        "OC",
                                        "web",
                                        "media",
                                        "Marketing",
                                        "AC_electric",
                                        "AC_mechanic",
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "InkBrushArabic",
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    selectedCommittee = newValue!;
                                  },
                                ),
                                SizedBox(height: 20.h),
                                TextField(
                                  controller: phoneNumberController,

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Phone Number",
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

                                ToggleSwitch(
                                  minWidth: double.infinity,
                                  initialLabelIndex: 0,
                                  cornerRadius: 12.r,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  animate: true,
                                  fontSize: 21.sp,
                                  iconSize: 21.sp,
                                  totalSwitches: 2,
                                  centerText: true,
                                  minHeight: 45.h,
                                  animationDuration: 400,
                                  curve: Curves.decelerate,
                                  labels: const [' Male', 'Female'],
                                  icons: const [Icons.male, Icons.female],
                                  activeBgColors: [
                                    [Colors.lightBlueAccent],
                                    [Colors.pink],
                                  ],
                                  onToggle: (index) {
                                    selectedGender = gender[index!];
                                    // setState(() {});
                                    // print('switched to: $index');
                                  },
                                ),
                                SizedBox(height: 20.h),
                                CustomButton(
                                  loginOnTap: registerOnTap,
                                  text: "Register",
                                ),
                                SizedBox(height: 20.h),
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
