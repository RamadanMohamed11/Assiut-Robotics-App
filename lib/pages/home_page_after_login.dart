import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/components_page.dart';
import 'package:robotics_app/pages/profile_page.dart';
import 'package:robotics_app/pages/team_info_page.dart';

class HomePageAfterLogin extends StatefulWidget {
  HomePageAfterLogin({
    super.key,
    required this.profileModel,
    this.indexBegin = 0,
  });
  final ProfileModel profileModel;
  int indexBegin;

  @override
  State<HomePageAfterLogin> createState() => _HomePageAfterLoginState();
}

class _HomePageAfterLoginState extends State<HomePageAfterLogin> {
  List<dynamic> pages = [];
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  void teamInfoMyProfileOnTap() {
    _page = 1;
    widget.indexBegin = 1;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.indexBegin != 0) {
      _page = widget.indexBegin;
    }
    pages = [
      TeamInfoPage(
        profileModel: widget.profileModel,
        myProfileOnTap: teamInfoMyProfileOnTap,
      ),
      ProfilePage(profileModel: widget.profileModel),
      ComponentsPage(profileModel: widget.profileModel),
      // TasksPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: widget.indexBegin,
        items: <Widget>[
          Icon(Icons.home, size: 32.sp, color: Colors.white),
          Icon(Icons.person, size: 32.sp, color: Colors.white),
          Icon(
            Icons.settings_input_component_rounded,
            size: 32.sp,
            color: Colors.white,
          ),
          // Icon(Icons.task_rounded, size: 32.sp, color: Colors.white),
        ],
        color: kPrimarycolor1,
        buttonBackgroundColor: kPrimarycolor2,
        backgroundColor: kOrangeColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _page = index;
            widget.indexBegin = index;
            print("Page: $_page");
          });
        },
        letIndexChange: (index) => true,
      ),
      body: pages[_page],
    );
  }
}
