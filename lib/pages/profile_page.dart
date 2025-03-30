import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/home_page.dart';
import 'package:robotics_app/services/change_image.dart';
import 'package:robotics_app/services/login_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.profileModel});
  static const String id = 'ProfilePage';
  ProfileModel profileModel;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  // ✅ Function to Pick Image & Upload
  Future<bool> uploadProfileImage(String token) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      print('❌ No image selected');
      return false;
    }

    File imageFile = File(pickedFile.path);
    await ProfileService().changeProfileImage(imageFile, token);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMessageDialog(
            context,
            false,
            true,
            "Do you want to sign out?",
            btnOkOnPress: () {
              final box = Hive.box('userData');
              box.put("token", "");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
          );
        },
        backgroundColor: kPrimarycolor1,
        child: Icon(Icons.exit_to_app, color: Colors.white, size: 30.sp),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimarycolor1, kPrimarycolor2],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: SizedBox(
                    width: double.infinity,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Member Dashboard",
                            style: TextStyle(
                              fontSize: 27.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontFamily: "AR Baghdad Font",
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 83.r,
                                backgroundColor: kOrangeColor,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 80.r,
                                  child:
                                      isLoading
                                          ? CircularProgressIndicator(
                                            backgroundColor: kOrangeColor,
                                            color: Colors.white,
                                            strokeWidth: 4.w,
                                          )
                                          : CachedNetworkImage(
                                            imageUrl:
                                                widget
                                                    .profileModel
                                                    .profileImage,
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
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                                      radius: 80.r,
                                                      backgroundImage:
                                                          imageProvider,
                                                    ),
                                          ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  isLoading = true;
                                  setState(() {});
                                  try {
                                    bool isImageChanged =
                                        await uploadProfileImage(
                                          widget.profileModel.token,
                                        );
                                    if (isImageChanged) {
                                      final box = Hive.box('userData');
                                      String userToken = box.get(
                                        "token",
                                        defaultValue: "",
                                      );
                                      dynamic data = await LoginService().login(
                                        email: box.get("email"),
                                        password: box.get("password"),
                                      );
                                      widget.profileModel =
                                          ProfileModel.fromJson(data["data"]);
                                      setState(() {});

                                      showMessageDialog(
                                        context,
                                        true,
                                        false,
                                        "Image changed successfully",
                                        btnOkOnPress: () {},
                                      );
                                    }
                                  } catch (e) {
                                    showMessageDialog(
                                      context,
                                      false,
                                      false,
                                      "Failed to change the image: ${e.toString().replaceFirst('Exception: ', '')}",
                                      btnOkOnPress: () {},
                                    );
                                  }
                                  isLoading = false;
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: kPrimarycolor1,
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.profileModel.name,
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontFamily: "AR Baghdad Font",
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.profileModel.role,
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontFamily: "AR Baghdad Font",
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(5.sp),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Icon(
                                          Icons.link,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          "Related Links",
                                          style: TextStyle(
                                            fontSize: 21.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            // fontFamily: "AR Baghdad Font",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: double.infinity,

                                    padding: EdgeInsets.all(5.sp),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,

                                      children: [
                                        Icon(
                                          Icons.date_range_outlined,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          "Lab Dates",
                                          style: TextStyle(
                                            fontSize: 21.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            // fontFamily: "AR Baghdad Font",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 50.h),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.w,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              "Email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // fontFamily: "AR Baghdad Font",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),

                        Center(
                          child: Text(
                            widget.profileModel.email,
                            style: TextStyle(
                              fontSize: 19.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontFamily: "AR Baghdad Font",
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                          indent: 40.w,
                          endIndent: 40.w,
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.w,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              "Committee",

                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // fontFamily: "AR Baghdad Font",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),

                        Center(
                          child: Text(
                            widget.profileModel.committee,

                            style: TextStyle(
                              fontSize: 19.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontFamily: "AR Baghdad Font",
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                          indent: 40.w,
                          endIndent: 40.w,
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            padding: EdgeInsets.all(5.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white,
                                width: 3.w,
                              ),
                            ),
                            child: Text(
                              "Phone",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // fontFamily: "AR Baghdad Font",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Center(
                          child: Text(
                            widget.profileModel.phoneNumber,
                            style: TextStyle(
                              fontSize: 19.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontFamily: "AR Baghdad Font",
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                          indent: 40.w,
                          endIndent: 40.w,
                        ),
                        SizedBox(height: 20.h),

                        Row(
                          children: [
                            Text(
                              "Status: ",
                              style: TextStyle(
                                fontSize: 19.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // fontFamily: "AR Baghdad Font",
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: 8.w,
                                left: 8.w,
                                // bottom: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    (widget.profileModel.verified
                                        ? "Verified"
                                        : "Not Verified"),
                                    style: TextStyle(
                                      fontSize: 19.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // fontFamily: "AR Baghdad Font",
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Icon(
                                    (widget.profileModel.verified
                                        ? Icons.verified
                                        : Icons.cancel),
                                    color: Colors.white,
                                    size: 21.sp,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
