import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/committe_page.dart';

class TeamInfoPage extends StatefulWidget {
  const TeamInfoPage({
    super.key,
    required this.profileModel,
    required this.myProfileOnTap,
  });
  final ProfileModel profileModel;
  final void Function() myProfileOnTap;
  @override
  State<TeamInfoPage> createState() => _TeamInfoPageState();
}

class _TeamInfoPageState extends State<TeamInfoPage> {
  bool isLoading = false;
  final List<String> committeesImages = [
    "assets/images/social.jpg",
    "assets/images/design.jpg",
    "assets/images/video.jpg",
  ];
  final List<String> committees = ["Social", "Design", "Video"];
  void committeeOnTap(int index) {
    Navigator.push(
      context,
      CustomSizeTransition(
        CommittePage(committe: committees[index]),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -3.h,
              right: -3.w,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Image(
                  image: AssetImage("assets/images/home_background.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 55.h),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: kOrangeColor,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 28.r,
                              child:
                                  isLoading
                                      ? CircularProgressIndicator(
                                        backgroundColor: kOrangeColor,
                                        color: Colors.white,
                                        strokeWidth: 4.w,
                                      )
                                      : CachedNetworkImage(
                                        imageUrl:
                                            widget.profileModel.profileImage,
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
                          SizedBox(width: 10.w),
                          InkWell(
                            onTap: widget.myProfileOnTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimarycolor1,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "My Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "Hello, ${widget.profileModel.name}!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Announcement",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    // "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Maecenas hendrerit luctus libero ac vulputate.",
                                    "First version of Assiut Robotics application is released",
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kOrangeColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(
                                            (0.1 * 255).toInt(),
                                          ),
                                          blurRadius: 10.r,
                                          spreadRadius: 2.r,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "About our team",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SizedBox(
                            height: 160.h,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.asset(
                                'assets/images/team.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "Committes",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 160.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: committeesImages.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // committeeOnTap(index);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Image.asset(
                                    committeesImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
