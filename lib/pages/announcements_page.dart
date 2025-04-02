import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/announcement_model.dart';
import 'package:robotics_app/services/get_announcement.dart';
import 'package:robotics_app/widgets/moving_logo.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AnnouncementModel>>(
        future: GetAnnouncement().getAnnouncement(),
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
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: announcements.length,
                    itemBuilder:
                        (context, index) => AnnouncementWidget(
                          title: announcements[index].title,
                          content: announcements[index].content,
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
    required this.title,
    required this.content,
  });
  final String title;
  final String content;
  @override
  State<AnnouncementWidget> createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimCard(title: widget.title, content: widget.content);
  }
}

class AnimCard extends StatefulWidget {
  const AnimCard({super.key, required this.title, required this.content});
  final String title;
  final String content;
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
              child: CardItem(title: widget.title, content: widget.content, () {
                setState(() {
                  padding = padding == 0 ? 150.h : 0.h;
                  bottomPadding = bottomPadding == 0 ? 150.h : 0.h;
                });
              }),
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
              child: Center(child: StaticLogo(isBlueLogo: false)),
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
                  fontSize: 16.sp,
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
