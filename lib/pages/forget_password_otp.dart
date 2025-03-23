import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/pages/forget_password_password.dart';
import 'package:robotics_app/services/verify_otp.dart';
import 'package:robotics_app/widgets/custom_text_field.dart';
import 'package:robotics_app/widgets/login_signup_button.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class ForgetPasswordOtp extends StatefulWidget {
  const ForgetPasswordOtp({super.key, required this.email});
  final String email;

  @override
  State<ForgetPasswordOtp> createState() => _ForgetPasswordOtpState();
}

class _ForgetPasswordOtpState extends State<ForgetPasswordOtp> {
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void verifyCodeOnTap() async {
      isLoading = true;
      setState(() {});
      try {
        await VerifyOtp().verifyOtp(
          email: widget.email,
          otp: textEditingController.text,
        );
        if (mounted) {
          Navigator.push(
            context,
            CustomSizeTransition(
              ForgetPasswordPassword(
                code: textEditingController.text,
                email: widget.email,
              ),
              alignment: Alignment.centerRight,
            ),
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
                        "Enter the code you received",
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
                        hintText: "Code",
                        isEmail: false,
                        isPassword: false,
                        isComponentPage: false,
                        isNumber: true,
                      ),
                      SizedBox(height: 100),
                      CustomButton(
                        loginOnTap: verifyCodeOnTap,
                        text: "Verify Code",
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
