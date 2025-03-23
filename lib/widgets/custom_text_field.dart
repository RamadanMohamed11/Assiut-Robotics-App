import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isEmail = false,
    this.isNumber = false,
    this.isPassword = false,
    this.isComponentPage = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isEmail;
  final bool isNumber;
  final bool isPassword;
  final bool isComponentPage;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType:
          widget.isEmail
              ? TextInputType.emailAddress
              : (widget.isNumber ? TextInputType.number : TextInputType.text),
      obscureText: isObscure && widget.isPassword,

      style: TextStyle(
        color: widget.isComponentPage ? kPrimarycolor2 : Colors.white,
        fontSize: 21.sp,
      ),
      decoration: InputDecoration(
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                )
                : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.isComponentPage ? kPrimarycolor2 : Colors.white,
          fontFamily:
              widget.isComponentPage ? "AR Baghdad Font" : "InkBrushArabic",
          fontSize: 25.sp,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.isComponentPage ? kPrimarycolor2 : Colors.white,
            width: 2.w,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.isComponentPage ? kPrimarycolor2 : Colors.white,
          ),
        ),
      ),
    );
  }
}
