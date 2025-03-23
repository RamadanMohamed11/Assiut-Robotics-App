import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/pages/login_page.dart';
import 'package:robotics_app/pages/register_page.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // half height of screen
              height: MediaQuery.of(context).size.height / 1.9,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimarycolor1, kPrimarycolor2],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.r),
                  bottomLeft: Radius.circular(50.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaticLogo(),

                  Text(
                    "Welcome to Robotics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "InkBrushArabic",
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 60.h),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CustomScaleTransition(
                    const RegisterPage(),
                    alignment: Alignment.topCenter,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: kPrimarycolor2,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "InkBrushArabic",
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "OR",
              style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CustomScaleTransition(
                    const LoginPage(),
                    alignment: Alignment.bottomCenter,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: kPrimarycolor2,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "InkBrushArabic",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
