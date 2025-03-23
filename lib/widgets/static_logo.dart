import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaticLogo extends StatelessWidget {
  const StaticLogo({super.key, this.isBlueLogo = false});
  final bool isBlueLogo;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 60.r,
      backgroundImage:
          isBlueLogo
              ? const AssetImage('assets/images/logo.ico')
              : const AssetImage('assets/images/Rob.png'),
    );
  }
}
