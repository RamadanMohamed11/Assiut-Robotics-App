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
    this.isRoundedBorder = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isEmail;
  final bool isNumber;
  final bool isPassword;
  final bool isComponentPage;
  final bool isRoundedBorder;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isRoundedBorder ? 40.h : null,
      child: TextField(
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
            color:
                widget.isComponentPage
                    ? (widget.isRoundedBorder ? Colors.grey : kPrimarycolor2)
                    : Colors.white,
            fontFamily: widget.isComponentPage ? "Manrope" : "InkBrushArabic",
            fontSize: 18.sp,
          ),
          alignLabelWithHint: widget.isRoundedBorder ? false : true,
          contentPadding:
              widget.isRoundedBorder
                  ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w)
                  : null,
          enabledBorder:
              widget.isRoundedBorder
                  ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(color: kPrimarycolor2, width: 1.w),
                  )
                  : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          widget.isComponentPage
                              ? kPrimarycolor2
                              : Colors.white,
                      width: 1.w,
                    ),
                  ),
          focusedBorder:
              widget.isRoundedBorder
                  ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(color: kPrimarycolor2, width: 1.w),
                  )
                  : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          widget.isComponentPage
                              ? kPrimarycolor2
                              : Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
