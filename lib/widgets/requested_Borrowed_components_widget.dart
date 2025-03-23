import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/models/borrowed_component_model.dart';
import 'package:robotics_app/models/requested_component_model.dart';
import 'package:robotics_app/services/accetp_request_to_borrow.dart';
import 'package:robotics_app/services/reject_reguest_to_borrow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:robotics_app/services/return_component.dart';

class RequestedBorrowedComponentsWidget extends StatefulWidget {
  const RequestedBorrowedComponentsWidget({
    super.key,
    this.requestComponent,
    required this.token,
    this.borrowedComponent,
    this.isBorrowedWidget = false,
  });

  final RequestedComponentModel? requestComponent;
  final BorrowedComponentModel? borrowedComponent;
  final bool isBorrowedWidget;
  final String token;

  @override
  State<RequestedBorrowedComponentsWidget> createState() =>
      _RequestedBorrowedComponentsWidgetState();
}

class _RequestedBorrowedComponentsWidgetState
    extends State<RequestedBorrowedComponentsWidget> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: kOrangeColor, width: 3.w),
          // color: kPrimarycolor2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color:
                    widget.isBorrowedWidget
                        ? (DateTime.now().isAfter(
                              DateTime.parse(
                                widget.borrowedComponent!.deadlineDate,
                              ),
                            )
                            ? Colors.red
                            : kPrimarycolor1)
                        : kPrimarycolor1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      widget.isBorrowedWidget
                          ? widget.borrowedComponent!.title
                          : widget.requestComponent!.title,
                      style: TextStyle(
                        color: kOrangeColor,
                        fontSize: 30.sp,
                        fontFamily: "AR Baghdad Font",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child:
                        (widget.isBorrowedWidget
                                    ? widget.borrowedComponent!.image
                                    : widget.requestComponent!.image) ==
                                'assets/images/Rob.png'
                            ? Image.asset(
                              'assets/images/Rob.png',
                              width: 150.w,
                              height: 150.h,
                            )
                            : FadeInImage.assetNetwork(
                              placeholder:
                                  'assets/images/Rob.png', // Replace with your placeholder asset
                              image:
                                  widget.isBorrowedWidget
                                      ? widget.borrowedComponent!.image
                                      : widget.requestComponent!.image,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, color: Colors.red);
                              },
                            ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name",
                          style: TextStyle(
                            color: kOrangeColor,
                            fontSize: 25.sp,
                            fontFamily: "AR Baghdad Font",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,

                        child: Text(
                          widget.isBorrowedWidget
                              ? widget.borrowedComponent!.memberName
                              : widget.requestComponent!.memberName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.sp,
                            fontFamily: "AR Baghdad Font",
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                  color: kOrangeColor,
                                  fontSize: 25.sp,
                                  fontFamily: "AR Baghdad Font",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.isBorrowedWidget
                                    ? widget
                                        .borrowedComponent!
                                        .memberPhoneNumber
                                    : widget
                                        .requestComponent!
                                        .memberPhoneNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontFamily: "AR Baghdad Font",
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Committee",
                                style: TextStyle(
                                  color: kOrangeColor,
                                  fontSize: 25.sp,
                                  fontFamily: "AR Baghdad Font",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.isBorrowedWidget
                                    ? widget.borrowedComponent!.memberCommittee
                                    : widget.requestComponent!.memberCommittee,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.sp,
                                  fontFamily: "AR Baghdad Font",
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: kOrangeColor,
                            radius: 78.r,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 75.r,
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.isBorrowedWidget
                                        ? widget.borrowedComponent!.memberImage
                                        : widget.requestComponent!.memberImage,
                                placeholder:
                                    (context, url) => Image.asset(
                                      'assets/images/Rob.png',
                                      fit: BoxFit.cover,
                                    ), // Loading effect
                                errorWidget:
                                    (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 40.sp,
                                    ), // Error widget
                                imageBuilder:
                                    (context, imageProvider) => CircleAvatar(
                                      radius: 75.r,
                                      backgroundImage: imageProvider,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.isBorrowedWidget
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Borrowed Date",
                                    style: TextStyle(
                                      color: kOrangeColor,
                                      fontSize: 25.sp,
                                      fontFamily: "AR Baghdad Font",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateTime.parse(
                                          widget.borrowedComponent!.borrowDate,
                                        )
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                        .split('-')
                                        .reversed
                                        .join('/'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.sp,
                                      fontFamily: "AR Baghdad Font",
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  Text(
                                    "Deadline Date",
                                    style: TextStyle(
                                      color: kOrangeColor,
                                      fontSize: 25.sp,
                                      fontFamily: "AR Baghdad Font",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateTime.parse(
                                          widget
                                              .borrowedComponent!
                                              .deadlineDate,
                                        )
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                        .split('-')
                                        .reversed
                                        .join('/'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.sp,
                                      fontFamily: "AR Baghdad Font",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            widget.isBorrowedWidget == false
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 6,

                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r),
                              ),
                            ),
                            builder: (BuildContext context) {
                              DateTime? tempSelectedDate = selectedDate;
                              return StatefulBuilder(
                                builder: (
                                  BuildContext context,
                                  StateSetter setModalState,
                                ) {
                                  return Padding(
                                    padding: EdgeInsets.all(20.sp),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Enter the return Date",
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "AR Baghdad Font",
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        GestureDetector(
                                          onTap: () async {
                                            tempSelectedDate =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                  ),
                                                  lastDate: DateTime(2100),
                                                );
                                            if (tempSelectedDate != null) {
                                              setModalState(() {});
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 15.h,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  tempSelectedDate == null
                                                      ? "Select Date"
                                                      : "${tempSelectedDate!.day.toString().padLeft(2, '0')}/${tempSelectedDate!.month.toString().padLeft(2, '0')}/${tempSelectedDate!.year}",
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color:
                                                        tempSelectedDate == null
                                                            ? Colors.grey
                                                            : kPrimarycolor1,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: kPrimarycolor1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (tempSelectedDate != null) {
                                              try {
                                                // Call the API to accept the request
                                                await AccetpRequestToBorrow()
                                                    .accetpRequestToBorrow(
                                                      token: widget.token,
                                                      componentId:
                                                          widget
                                                              .requestComponent!
                                                              .componentID,
                                                      borrowDate:
                                                          DateTime.now()
                                                              .toUtc()
                                                              .toIso8601String(),
                                                      deadlineDate:
                                                          tempSelectedDate!
                                                              .toUtc()
                                                              .toIso8601String(),
                                                    );

                                                // Show success dialog
                                                if (mounted) {
                                                  showMessageDialog(
                                                    context,
                                                    true,
                                                    false,
                                                    "Request accepted successfully",
                                                    btnOkOnPress: () {
                                                      Navigator.pop(
                                                        context,
                                                      ); // Close the modal after success
                                                    },
                                                  );
                                                }
                                              } catch (e) {
                                                // Show error dialog
                                                if (mounted) {
                                                  showMessageDialog(
                                                    context,
                                                    false,
                                                    false,
                                                    "Failed to Accept request: ${e.toString().replaceFirst('Exception: ', '')}",
                                                    btnOkOnPress: () {},
                                                  );
                                                }
                                              }
                                            } else {
                                              // Show a warning if no date is selected
                                              if (mounted) {
                                                showMessageDialog(
                                                  context,
                                                  false,
                                                  false,
                                                  "Please select a return date before submitting.",
                                                  btnOkOnPress: () {},
                                                );
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kOrangeColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              fontFamily: "AR Baghdad Font",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: kOrangeColor, width: 3.w),
                            color: Colors.green,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Center(
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27.sp,
                                  fontFamily: "AR Baghdad Font",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        onTap: () async {
                          try {
                            await RejectReguestToBorrow().rejectReguestToBorrow(
                              widget.token,
                              widget.requestComponent!.componentID,
                            );
                            setState(() {});
                            showMessageDialog(
                              context,
                              true,
                              false,
                              "Request rejected successfully",
                              btnOkOnPress: () {},
                            );
                          } catch (e) {
                            showMessageDialog(
                              context,
                              false,
                              false,
                              "Failed to reject request: ${e.toString().replaceFirst('Exception: ', '')}",
                              btnOkOnPress: () {},
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: kOrangeColor, width: 3.w),
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Center(
                              child: Text(
                                "Reject",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27.sp,
                                  fontFamily: "AR Baghdad Font",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          try {
                            await ReturnComponent().returnComponent(
                              token: widget.token,
                              componentId:
                                  widget.borrowedComponent!.componentID,
                            );
                            setState(() {});
                            showMessageDialog(
                              context,
                              true,
                              false,
                              "Component returned successfully",
                              btnOkOnPress: () {},
                            );
                          } catch (e) {
                            showMessageDialog(
                              context,
                              false,
                              false,
                              "Failed to return component: ${e.toString().replaceFirst('Exception: ', '')}",
                              btnOkOnPress: () {},
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: kOrangeColor, width: 3.w),
                            color:
                                DateTime.now().isAfter(
                                      DateTime.parse(
                                        widget.borrowedComponent!.deadlineDate,
                                      ),
                                    )
                                    ? Colors.red
                                    : kPrimarycolor1,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Center(
                              child: Text(
                                "Return",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27.sp,
                                  fontFamily: "AR Baghdad Font",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
