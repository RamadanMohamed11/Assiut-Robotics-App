import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/announcement_model.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/add_announcement_page.dart';
import 'package:robotics_app/services/delete_announcement.dart';
import 'package:robotics_app/services/get_announcement.dart';
import 'package:robotics_app/widgets/moving_logo.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({
    super.key,
    required this.index,
    required this.profileModel,
  });
  final int index;
  final ProfileModel profileModel;
  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;
  late ScrollController _scrollController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.index);
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true); // Repeat the animation in reverse

    _animation = Tween<double>(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex() {
    if (_scrollController.hasClients) {
      // Calculate the offset based on the index and item width
      double offset = widget.index * 285.w; // Adjust item width as needed
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AnnouncementModel>>(
        future: GetAnnouncement().getAnnouncement(
          committee: widget.profileModel.committee,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: MovingLogo(
                animationController: _animationController,
                animation: _animation,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaticLogo(isBlueLogo: true),
                  Text(
                    "No Announcements",
                    style: TextStyle(
                      color: kPrimarycolor1,
                      fontSize: 33.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "AR Baghdad Font",
                    ),
                  ),
                ],
              ),
            );
          } else {
            List<AnnouncementModel> announcements = snapshot.data!;

            // Scroll to the specified index after the ListView is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToIndex();
            });

            return Column(
              children: [
                SizedBox(height: 75.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Announcements",
                      style: TextStyle(
                        color: kPrimarycolor1,
                        fontSize: 33.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.notifications, color: kOrangeColor, size: 35.sp),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: announcements.length,
                    itemBuilder:
                        (context, index) => AnnouncementWidget(
                          announcement: announcements[index],
                          profileModel: widget.profileModel,
                        ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AnnouncementWidget extends StatefulWidget {
  const AnnouncementWidget({
    super.key,
    required this.announcement,
    required this.profileModel,
  });
  final AnnouncementModel announcement;
  final ProfileModel profileModel;
  @override
  State<AnnouncementWidget> createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimCard(
      announcement: widget.announcement,
      profileModel: widget.profileModel,
    );
  }
}

class AnimCard extends StatefulWidget {
  const AnimCard({
    super.key,
    required this.announcement,
    required this.profileModel,
  });
  final AnnouncementModel announcement;
  final ProfileModel profileModel;
  @override
  State<AnimCard> createState() => _AnimCardState();
}

class _AnimCardState extends State<AnimCard> {
  var padding = 150.h;
  var bottomPadding = 0.h;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPadding(
            padding: EdgeInsets.only(top: padding, bottom: bottomPadding),
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Container(
              child: CardItem(
                title: widget.announcement.title,
                content: widget.announcement.content,
                () {
                  setState(() {
                    padding = padding == 0 ? 150.h : 0.h;
                    bottomPadding = bottomPadding == 0 ? 150.h : 0.h;
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 20.w, left: 20.w, top: 200.h),
              height: 180.h,
              width: 250.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30.r,
                  ),
                ],
                color: kPrimarycolor2,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30.r),
                ),
              ),
              child: Center(
                child:
                    (widget.profileModel.role == "leader" ||
                            widget.profileModel.role.contains("head"))
                        ? Column(
                          children: [
                            StaticLogo(isBlueLogo: false),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      showMessageDialog(
                                        context,
                                        false,
                                        true,
                                        "Are you sure you want to delete this announcement?",
                                        btnOkOnPress: () async {
                                          try {
                                            await DeleteAnnouncement()
                                                .deleteAnnouncement(
                                                  widget.announcement.id,
                                                );
                                            showMessageDialog(
                                              context,
                                              true,
                                              false,
                                              "Announcement deleted successfully",
                                              btnOkOnPress: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  CustomSizeTransition(
                                                    AnnouncementsPage(
                                                      index: 0,
                                                      profileModel:
                                                          widget.profileModel,
                                                    ),
                                                    alignment:
                                                        Alignment.centerRight,
                                                  ),
                                                );
                                              },
                                            );
                                          } catch (e) {
                                            showMessageDialog(
                                              context,
                                              false,
                                              false,
                                              "Failed to delete announcement: ${e.toString().replaceFirst('Exception: ', '')}",
                                              btnOkOnPress: () {},
                                            );
                                          }
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 25.sp,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CustomSizeTransition(
                                          AddAnnouncementPage(
                                            isEdit: true,
                                            announcementModel:
                                                widget.announcement,
                                            profileModel: widget.profileModel,
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: kOrangeColor,
                                      size: 25.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : StaticLogo(isBlueLogo: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem(
    this.onTap, {
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220.h,
        width: 240.w,
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xffFF6594).withOpacity(0.2),
              blurRadius: 25.r,
            ),
          ],
          color: kOrangeColor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
