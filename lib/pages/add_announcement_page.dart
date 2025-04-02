import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/announcement_model.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/home_page_after_login.dart';
import 'package:robotics_app/services/add_announcement.dart';
import 'package:robotics_app/services/edit_announcement.dart';
import 'package:robotics_app/widgets/custom_text_field.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class AddAnnouncementPage extends StatefulWidget {
  const AddAnnouncementPage({
    super.key,
    this.profileModel,
    this.isEdit = false,
    this.announcementModel,
  });
  final ProfileModel? profileModel;
  final AnnouncementModel? announcementModel;
  final bool isEdit;
  @override
  State<AddAnnouncementPage> createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();
  DateTime? tempSelectedDate;
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      titleController.text = widget.announcementModel!.title;
      contentController.text = widget.announcementModel!.content;
      tempSelectedDate = DateTime.tryParse(
        widget.announcementModel!.dateOfDelete,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),

                StaticLogo(isBlueLogo: true),
                Text("Add Announcement", style: TextStyle(fontSize: 30.sp)),
                SizedBox(height: 75.h),
                CustomTextField(
                  controller: titleController,
                  hintText: "Title",
                  isEmail: false,
                  isComponentPage: true,
                  isNumber: false,
                  isPassword: false,
                  isRoundedBorder: true,
                ),
                SizedBox(height: 25.h),
                CustomTextField(
                  controller: contentController,
                  hintText: "Content",
                  isEmail: false,
                  isComponentPage: true,
                  isNumber: false,
                  isPassword: false,
                  isRoundedBorder: true,
                  linesNumber: 3,
                ),
                SizedBox(height: 25.h),

                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            tempSelectedDate = await showDatePicker(
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
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kPrimarycolor2,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tempSelectedDate == null
                                        ? "Select When the announcement will be deleted"
                                        : "${tempSelectedDate!.day.toString().padLeft(2, '0')}/${tempSelectedDate!.month.toString().padLeft(2, '0')}/${tempSelectedDate!.year}",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color:
                                          tempSelectedDate == null
                                              ? Colors.grey
                                              : kPrimarycolor1,
                                    ),
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
                        SizedBox(height: 50.h),

                        ElevatedButton(
                          onPressed: () async {
                            if (widget.isEdit == false) {
                              if (tempSelectedDate != null) {
                                try {
                                  // Show success dialog
                                  await AddAnnouncement().addAnnouncement(
                                    title: titleController.text.trim(),
                                    content: contentController.text.trim(),
                                    dateOfDelete:
                                        "${tempSelectedDate!.year}-${tempSelectedDate!.month.toString().padLeft(2, '0')}-${tempSelectedDate!.day.toString().padLeft(2, '0')}",
                                    token: widget.profileModel!.token,
                                  );
                                  if (mounted) {
                                    showMessageDialog(
                                      context,
                                      true,
                                      false,
                                      "Announcement added successfully",
                                      btnOkOnPress: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          CustomScaleTransition(
                                            HomePageAfterLogin(
                                              profileModel:
                                                  widget.profileModel!,
                                              indexBegin: 0,
                                            ),
                                            alignment: Alignment.bottomCenter,
                                          ),
                                          (route) => false,
                                        );
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
                                      "Failed to add announcement: ${e.toString().replaceFirst('Exception: ', '')}",
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
                                    "Please select a date.",
                                    btnOkOnPress: () {},
                                  );
                                }
                              }
                            } else {
                              try {
                                // Show success dialog
                                await EditAnnouncement().editAnnouncement(
                                  title: titleController.text.trim(),
                                  content: contentController.text.trim(),
                                  dateOfDelete:
                                      "${tempSelectedDate!.year}-${tempSelectedDate!.month.toString().padLeft(2, '0')}-${tempSelectedDate!.day.toString().padLeft(2, '0')}",
                                  token: widget.profileModel!.token,
                                  announcementId: widget.announcementModel!.id,
                                );
                                if (mounted) {
                                  showMessageDialog(
                                    context,
                                    true,
                                    false,
                                    "Announcement updated successfully",
                                    btnOkOnPress: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CustomScaleTransition(
                                          HomePageAfterLogin(
                                            profileModel: widget.profileModel!,
                                            indexBegin: 0,
                                          ),
                                          alignment: Alignment.bottomCenter,
                                        ),
                                        (route) => false,
                                      );
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
                                    "Failed to edit announcement: ${e.toString().replaceFirst('Exception: ', '')}",
                                    btnOkOnPress: () {},
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kOrangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            widget.isEdit ? "Edit" : "Submit",
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
