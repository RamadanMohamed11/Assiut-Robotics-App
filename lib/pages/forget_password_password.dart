import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/pages/login_page.dart';
import 'package:robotics_app/services/change_password.dart';
import 'package:robotics_app/widgets/custom_text_field.dart';
import 'package:robotics_app/widgets/login_signup_button.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class ForgetPasswordPassword extends StatefulWidget {
  const ForgetPasswordPassword({
    super.key,
    required this.email,
    required this.code,
  });
  final String email;
  final String code;

  @override
  State<ForgetPasswordPassword> createState() => _ForgetPasswordPasswordState();
}

class _ForgetPasswordPasswordState extends State<ForgetPasswordPassword> {
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void changePasswordOnTap() async {
      isLoading = true;
      setState(() {});
      try {
        await ChangePassword().changePassword(
          email: widget.email,
          newPassword: textEditingController.text,
          code: widget.code,
        );
        if (mounted) {
          showMessageDialog(
            context,
            true,
            false,
            'Password changed successfully',
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                CustomSizeTransition(LoginPage(), alignment: Alignment.center),
                (route) => false,
              );
            },
          );
        }
      } catch (e) {
        if (mounted) {
          showMessageDialog(
            context,
            false,
            false,
            e.toString().replaceFirst('Exception: ', ''),
            btnOkOnPress: () {},
          );
        }
      }
      isLoading = false;
      setState(() {});
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(45.0.sp),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimarycolor1, kPrimarycolor2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child:
              isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kOrangeColor,
                      color: Colors.white,
                      strokeWidth: 4.w,
                    ),
                  )
                  : Column(
                    children: [
                      StaticLogo(),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "InkBrushArabic",
                        ),
                      ),
                      SizedBox(height: 100),
                      Text(
                        "Enter your new password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "InkBrushArabic",
                        ),
                      ),
                      SizedBox(height: 50),
                      CustomTextField(
                        controller: textEditingController,
                        hintText: "Password",
                        isEmail: false,
                        isPassword: true,
                        isComponentPage: false,
                        isNumber: false,
                      ),
                      SizedBox(height: 100),
                      CustomButton(
                        loginOnTap: changePasswordOnTap,
                        text: "Change Password",
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
