import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/models/component_model.dart';
import 'package:robotics_app/services/request_to_borrow.dart';

class ComponentWidget extends StatefulWidget {
  const ComponentWidget({
    super.key,
    required this.component,
    required this.token,
  });

  final ComponentModel component;
  final String token;

  @override
  _ComponentWidgetState createState() => _ComponentWidgetState();
}

class _ComponentWidgetState extends State<ComponentWidget> {
  Future<void> _handleRequest() async {
    try {
      await RequestToBorrow().requestToBorrow(
        token: widget.token,
        componentId: widget.component.componentID,
      );

      if (mounted) {
        showMessageDialog(
          context,
          true,
          false,
          'Component requested successfully',
          btnOkOnPress: () {},
        );
      }
    } catch (e) {
      if (mounted) {
        showMessageDialog(
          context,
          false,
          false,
          'Failed to send request: ${e.toString().replaceFirst('Exception: ', '')}',
          btnOkOnPress: () {},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10.sp),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              colors: [kPrimarycolor1, kPrimarycolor2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child:
                      widget.component.image == 'assets/images/Rob.png'
                          ? Image.asset('assets/images/Rob.png')
                          : FadeInImage.assetNetwork(
                            placeholder:
                                'assets/images/Rob.png', // Replace with your placeholder asset
                            image: widget.component.image,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                          ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(8.0.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5.w),
                    color: kPrimarycolor2,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: SelectableText(
                      widget.component.title,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "AR Baghdad Font",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(8.0.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5.w),
                    color: kPrimarycolor2,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: InkWell(
                      onTap: _handleRequest,
                      child: Text(
                        "Request",
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "AR Baghdad Font",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
