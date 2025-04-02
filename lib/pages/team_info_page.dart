import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/announcement_model.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/add_announcement_page.dart';
import 'package:robotics_app/pages/announcements_page.dart';
import 'package:robotics_app/pages/committe_page.dart';
import 'package:robotics_app/services/get_announcement.dart';

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

class _TeamInfoPageState extends State<TeamInfoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true); // Repeat the animation in reverse

    _animation = Tween<double>(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Listen to animation status changes
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.reverse) {
        await _audioPlayer.stop();
      }
      if (status == AnimationStatus.forward) {
        if (isLoading == true) {
          await _audioPlayer.setVolume(1.2);
          await _audioPlayer.setPlaybackRate(1); // Increase speed (1.5x faster)
          await _audioPlayer.play(AssetSource('sounds/peo.mp3'));
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

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
                      FutureBuilder<List<AnnouncementModel>>(
                        future: GetAnnouncement().getAnnouncement(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: kOrangeColor,
                                color: Colors.white,
                                strokeWidth: 4.w,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.data!.isEmpty) {
                            return Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(
                                          (0.1 * 255).toInt(),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.r),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "No announcements",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CustomScaleTransition(
                                        AddAnnouncementPage(
                                          token: widget.profileModel.token,
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    );
                                  },
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
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            List<AnnouncementModel> announcements =
                                snapshot.data!;
                            return Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(
                                          (0.1 * 255).toInt(),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.r),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            announcements[0].title,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  announcements[0].content,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    CustomScaleTransition(
                                                      AnnouncementsPage(),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    ),
                                                  );
                                                },
                                                icon: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: kOrangeColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withAlpha(
                                                              (0.1 * 255)
                                                                  .toInt(),
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
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CustomScaleTransition(
                                        AddAnnouncementPage(
                                          token: widget.profileModel.token,
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    );
                                  },
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
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
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
