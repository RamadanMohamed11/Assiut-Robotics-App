import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/component_model.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/manage_component_page.dart';
import 'package:robotics_app/services/delete_one_component.dart';
import 'package:robotics_app/services/request_to_borrow.dart';

class ComponentWidget extends StatefulWidget {
  const ComponentWidget({
    super.key,
    required this.component,
    required this.profileModel,
  });

  final ComponentModel component;
  final ProfileModel profileModel;

  @override
  _ComponentWidgetState createState() => _ComponentWidgetState();
}

class _ComponentWidgetState extends State<ComponentWidget> {
  bool isLoading = false;
  Future<void> _handleRequest() async {
    try {
      await RequestToBorrow().requestToBorrow(
        token: widget.profileModel.token,
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
    return isLoading
        ? Center(
          child: CircularProgressIndicator(
            backgroundColor: kOrangeColor,
            color: Colors.white,
            strokeWidth: 4.w,
          ),
        )
        : ((widget.profileModel.role.toLowerCase() == "leader" ||
                widget.profileModel.committee.toLowerCase() == "oc")
            ? Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              background: Container(
                padding: EdgeInsets.all(10.sp),
                alignment: Alignment.centerLeft,
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 30.sp),
                    Text(
                      'Edit',
                      style: TextStyle(color: Colors.white, fontSize: 22.sp),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                padding: EdgeInsets.all(10.sp),
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.white, size: 30.sp),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.white, fontSize: 22.sp),
                    ),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  // Handle edit action
                  // You can navigate to an edit screen or show an edit dialog
                  Navigator.push(
                    context,
                    CustomSizeTransition(
                      ManageComponentPage(
                        token: widget.profileModel.token,
                        component: widget.component,
                        profileModel: widget.profileModel,
                        isEdit: true,
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  );
                  return false; // Prevent dismissal for edit
                } else if (direction == DismissDirection.endToStart) {
                  // Handle delete action
                  return await showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            'Delete Component',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to delete this Component?',
                            style: TextStyle(fontSize: 19.sp),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                // Handle delete action
                                // isLoading = true;
                                // setState(() {});
                                await DeleteOneComponent().deleteOneComponent(
                                  token: widget.profileModel.token,
                                  componentId: widget.component.componentID,
                                );
                                // isLoading = false;
                                // setState(() {});
                                if (mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              },
                            ),
                          ],
                        ),
                  );
                }
                return false;
              },
              child: ComponentWidgetWithoutDismissble(
                component: widget.component,
                handleRequest: _handleRequest,
              ),
            )
            : ComponentWidgetWithoutDismissble(
              component: widget.component,
              handleRequest: _handleRequest,
            ));
  }
}

class ComponentWidgetWithoutDismissble extends StatelessWidget {
  const ComponentWidgetWithoutDismissble({
    super.key,
    required this.component,
    this.handleRequest,
  });
  final ComponentModel component;
  final void Function()? handleRequest;

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
                      component.image == 'assets/images/Rob.png'
                          ? Image.asset('assets/images/Rob.png')
                          : FadeInImage.assetNetwork(
                            placeholder: 'assets/images/Rob.png',
                            image: component.image,
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
                      component.title,
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
                      onTap: handleRequest,
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
