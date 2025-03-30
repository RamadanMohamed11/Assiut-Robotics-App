import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/borrow_component_page.dart';
import 'package:robotics_app/pages/get_component_page.dart';
import 'package:robotics_app/pages/manage_component_page.dart';
import 'package:robotics_app/pages/requested_components_page.dart';
import 'package:robotics_app/pages/search_page.dart';
import 'package:robotics_app/widgets/custom_drawer.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key, required this.profileModel});
  final ProfileModel profileModel;

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  String selectedItem = "All";
  String appBarTitle = "Components";

  void item1OnTap() {
    selectedItem = "All";
    Navigator.pop(context);
    setState(() {});
  }

  void item2OnTap() {
    selectedItem = "Requested";
    appBarTitle = "Requested Components";
    Navigator.pop(context);
    setState(() {});
  }

  void item3OnTap() {
    selectedItem = "Borrowed";
    appBarTitle = "Borrowed Components";
    Navigator.pop(context);
    setState(() {});
  }

  void item4OnTap() {
    selectedItem = "Manage";
    appBarTitle = "Manage Components";
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pages = {
      "All": GetComponentPage(profileModel: widget.profileModel),
      "Requested": RequestedComponentsPage(token: widget.profileModel.token),
      "Borrowed": BorrowComponentPage(token: widget.profileModel.token),
      "Manage": ManageComponentPage(token: widget.profileModel.token),
    };
    void onPressedSearchIcon() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(profileModel: widget.profileModel),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Text(
            appBarTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontFamily: "AR Baghdad Font",
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimarycolor2,
        actions: [
          selectedItem == "All"
              ? IconButton(
                onPressed: onPressedSearchIcon,
                icon: Icon(Icons.search, color: Colors.white, size: 30.sp),
              )
              : SizedBox(),
        ],
      ),
      drawer:
          widget.profileModel.role.toLowerCase() == "leader" ||
                  widget.profileModel.committee.toLowerCase() == "oc"
              ? CustomDrawer(
                selectedItem: selectedItem,
                onTap1: item1OnTap,
                onTap2: item2OnTap,
                onTap3: item3OnTap,
                onTap4: item4OnTap,
              )
              : null,
      body: pages[selectedItem],
    );
  }
}
