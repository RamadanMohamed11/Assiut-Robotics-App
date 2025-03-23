import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';

void showMessageDialog(
  BuildContext context,
  bool isSuccessful,
  bool isSignout,
  String message, {
  void Function()? btnOkOnPress,
}) {
  AwesomeDialog(
    dialogBackgroundColor: kPrimarycolor2,
    context: context,
    animType: AnimType.bottomSlide,
    dialogType:
        (isSuccessful)
            ? DialogType.success
            : (isSignout)
            ? DialogType.question
            : DialogType.error,
    title:
        isSuccessful
            ? "Success"
            : (isSignout)
            ? "Signout"
            : "Error",
    titleTextStyle: TextStyle(
      color: isSuccessful ? Colors.greenAccent : Colors.redAccent,
      fontSize: 22.sp,
      fontWeight: FontWeight.bold,
    ),
    desc: message,
    descTextStyle: TextStyle(
      fontSize: 20.sp,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    btnOkText: "Ok",
    buttonsTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    ),
    btnOkOnPress: btnOkOnPress,
  ).show();
}
