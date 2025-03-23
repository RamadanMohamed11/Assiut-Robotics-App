import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum MenuItem { requested, borrowed, manage }

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.selectedItem,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
    required this.onTap4,
  });
  final String selectedItem;
  final void Function() onTap1;
  final void Function() onTap2;
  final void Function() onTap3;
  final void Function() onTap4;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.lightBlue, // Background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h), // Top spacing
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Text(
                "Metaphor",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            DrawerItem(
              title: "All Components",
              isSelected: selectedItem == "All",
              onTap: onTap1,
            ),
            DrawerItem(
              title: "Requested Components",
              isSelected: selectedItem == "Requested",
              onTap: onTap2,
            ),
            DrawerItem(
              title: "Borrowed Components",
              isSelected: selectedItem == "Borrowed",
              onTap: onTap3,
            ),
            DrawerItem(
              title: "Manage Components",
              isSelected: selectedItem == "Manage",
              onTap: onTap4,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopupMenu extends StatefulWidget {
  final String selectedItem;

  const CustomPopupMenu({super.key, required this.selectedItem});

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  MenuItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      initialValue: selectedMenu,
      onSelected: (MenuItem item) {
        setState(() {
          selectedMenu = item;
        });

        // Handle navigation or actions based on the selected item
        switch (item) {
          case MenuItem.requested:
            Navigator.pop(context); // Close the menu
            // Handle "Requested component" action
            break;
          case MenuItem.borrowed:
            Navigator.pop(context); // Close the menu
            // Handle "Borrowed component" action
            break;
          case MenuItem.manage:
            Navigator.pop(context); // Close the menu
            // Handle "Manage component" action
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<MenuItem>>[
            PopupMenuItem<MenuItem>(
              value: MenuItem.requested,
              child: Text(
                "Requested component",
                style: TextStyle(
                  fontWeight:
                      widget.selectedItem == "Requested"
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color:
                      widget.selectedItem == "Requested"
                          ? Colors.blueAccent
                          : Colors.black,
                ),
              ),
            ),
            PopupMenuItem<MenuItem>(
              value: MenuItem.borrowed,
              child: Text(
                "Borrowed component",
                style: TextStyle(
                  fontWeight:
                      widget.selectedItem == "Borrowed"
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color:
                      widget.selectedItem == "Borrowed"
                          ? Colors.blueAccent
                          : Colors.black,
                ),
              ),
            ),
            PopupMenuItem<MenuItem>(
              value: MenuItem.manage,
              child: Text(
                "Manage component",
                style: TextStyle(
                  fontWeight:
                      widget.selectedItem == "Manage"
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color:
                      widget.selectedItem == "Manage"
                          ? Colors.blueAccent
                          : Colors.black,
                ),
              ),
            ),
          ],
    );
  }
}
