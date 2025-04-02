import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommittePage extends StatelessWidget {
  const CommittePage({super.key, required this.committe});
  final String committe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(committe, style: TextStyle(fontSize: 30.sp))),
    );
  }
}
