import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.loginOnTap, required this.text});

  final String text;
  final void Function()? loginOnTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loginOnTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28.sp,
            color: kPrimarycolor1,
            fontFamily: "InkBrushArabic",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
