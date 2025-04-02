import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/helper/show_dialog.dart';
import 'package:robotics_app/helper/transitions.dart';
import 'package:robotics_app/models/add_component_model.dart';
import 'package:robotics_app/models/component_model.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/home_page_after_login.dart';
import 'package:robotics_app/services/add_component.dart';
import 'package:robotics_app/services/update_component.dart';
import 'package:robotics_app/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:robotics_app/widgets/login_signup_button.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class ManageComponentPage extends StatefulWidget {
  const ManageComponentPage({
    super.key,
    required this.token,
    this.isEdit = false,
    this.component,
    this.profileModel,
  });
  final String token;
  final ComponentModel? component;
  final bool isEdit;
  final ProfileModel? profileModel;

  @override
  State<ManageComponentPage> createState() => _ManageComponentPageState();
}

class _ManageComponentPageState extends State<ManageComponentPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  File? imageFile;
  bool isAddLoading = false;

  void uploadImageMethod() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'No image selected',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  void addComponentMethod() async {
    isAddLoading = true;
    setState(() {});
    try {
      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image first')),
        );
        return;
      }

      AddComponentModel addComponentModel = AddComponentModel(
        title: titleController.text.trim(),
        price: priceController.text.trim(),
        count: countController.text.trim(),
        location: locationController.text.trim(),
        category: categoryController.text.trim(),
      );

      await AddComponent().addComponent(
        widget.token,
        addComponentModel,
        imageFile!,
      );
      showMessageDialog(
        context,
        true,
        false,
        "Component added successfully!",
        btnOkOnPress: () {
          Navigator.pushAndRemoveUntil(
            context,
            CustomScaleTransition(
              HomePageAfterLogin(
                profileModel: widget.profileModel!,
                indexBegin: 2,
              ),
              alignment: Alignment.bottomCenter,
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showMessageDialog(
        context,
        false,
        false,
        e.toString().replaceFirst('Exception: ', ''),
        btnOkOnPress: () {},
      );
    }
    isAddLoading = false;
    setState(() {});
  }

  void editComponentMethod() async {
    try {
      await UpdateComponent().updateComponent({
        "id": widget.component!.componentID,
        "title": titleController.text.trim(),
        "price": priceController.text.trim(),
        "category": categoryController.text.trim(),
      }, widget.token);
      showMessageDialog(
        context,
        true,
        false,
        "Component updated successfully!",
        btnOkOnPress: () {
          Navigator.pushAndRemoveUntil(
            context,
            CustomSizeTransition(
              HomePageAfterLogin(
                profileModel: widget.profileModel!,
                indexBegin: 2,
              ),
              alignment: Alignment.centerLeft,
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showMessageDialog(
        context,
        false,
        false,
        e.toString().replaceFirst('Exception: ', ''),
        btnOkOnPress: () {},
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.component != null) {
      titleController.text = widget.component?.title ?? '';
      priceController.text = widget.component?.price.toString() ?? '';
      categoryController.text = widget.component?.category ?? '';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    countController.dispose();
    locationController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isEdit
              ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Text(
                    "Edit Component",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontFamily: "AR Baghdad Font",
                    ),
                  ),
                ),
                centerTitle: true,
                backgroundColor: kPrimarycolor2,
              )
              : null,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.w,
                    vertical: 1.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        widget.isEdit
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child:
                                  widget.component?.image ==
                                          'assets/images/Rob.png'
                                      ? Image.asset('assets/images/Rob.png')
                                      : FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/Rob.png',
                                        image: widget.component!.image,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          );
                                        },
                                      ),
                            )
                            : StaticLogo(isBlueLogo: true),
                        Text(
                          widget.isEdit ? "Edit Component" : "Add Component",
                          style: TextStyle(
                            color: kPrimarycolor2,
                            fontSize: 33.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: titleController,
                          hintText: "Title",
                          isComponentPage: true,
                          isEmail: false,
                          isNumber: false,
                          isPassword: false,
                          isRoundedBorder: true,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: priceController,
                          hintText: "Price",
                          isComponentPage: true,
                          isEmail: false,
                          isNumber: true,
                          isPassword: false,
                          isRoundedBorder: true,
                        ),
                        SizedBox(height: 20.h),
                        widget.isEdit
                            ? SizedBox()
                            : CustomTextField(
                              controller: countController,
                              hintText: "Count",
                              isComponentPage: true,
                              isEmail: false,
                              isNumber: true,
                              isPassword: false,
                              isRoundedBorder: true,
                            ),
                        SizedBox(height: widget.isEdit ? 0 : 20.h),
                        widget.isEdit
                            ? SizedBox()
                            : CustomTextField(
                              controller: locationController,
                              hintText: "Location",
                              isComponentPage: true,
                              isEmail: false,
                              isNumber: false,
                              isPassword: false,
                              isRoundedBorder: true,
                            ),
                        SizedBox(height: widget.isEdit ? 0 : 20.h),
                        CustomTextField(
                          controller: categoryController,
                          hintText: "Category",
                          isComponentPage: true,
                          isEmail: false,
                          isNumber: false,
                          isPassword: false,
                          isRoundedBorder: true,
                        ),
                        SizedBox(height: widget.isEdit ? 0 : 20.h),
                        widget.isEdit
                            ? SizedBox()
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  text: "Upload Image",
                                  loginOnTap: uploadImageMethod,
                                  isLoginOrSignup: false,
                                ),
                                Icon(
                                  imageFile != null ? Icons.check : Icons.close,
                                  color:
                                      imageFile != null
                                          ? Colors.green
                                          : Colors.red,
                                  size: 30.sp,
                                ),
                              ],
                            ),
                        SizedBox(height: 50.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text:
                                    widget.isEdit
                                        ? "Edit Component"
                                        : "Add Component",
                                loginOnTap:
                                    widget.isEdit
                                        ? editComponentMethod
                                        : addComponentMethod,
                                isLoginOrSignup: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isAddLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: kOrangeColor,
                  color: Colors.white,
                  strokeWidth: 4.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
