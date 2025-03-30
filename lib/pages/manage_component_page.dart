import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/add_component_model.dart';
import 'package:robotics_app/services/add_component.dart';
import 'package:robotics_app/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:robotics_app/widgets/login_signup_button.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class ManageComponentPage extends StatefulWidget {
  const ManageComponentPage({super.key, required this.token});
  final String token;

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

  void uploadImageMethod() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selected: ${imageFile!.path}')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  void addComponentMethod() async {
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

    await AddComponent()
        .addComponent(widget.token, addComponentModel, imageFile!)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Component added successfully!')),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add component: $error')),
          );
        });
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 1.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    StaticLogo(isBlueLogo: true),

                    Text(
                      "Add Component",
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

                    CustomTextField(
                      controller: countController,
                      hintText: "Count",
                      isComponentPage: true,
                      isEmail: false,
                      isNumber: true,
                      isPassword: false,
                      isRoundedBorder: true,
                    ),
                    SizedBox(height: 20.h),

                    CustomTextField(
                      controller: locationController,
                      hintText: "Location",
                      isComponentPage: true,
                      isEmail: false,
                      isNumber: false,
                      isPassword: false,
                      isRoundedBorder: true,
                    ),
                    SizedBox(height: 20.h),

                    CustomTextField(
                      controller: categoryController,
                      hintText: "Category",
                      isComponentPage: true,
                      isEmail: false,
                      isNumber: false,
                      isPassword: false,
                      isRoundedBorder: true,
                    ),

                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: "Upload Image",
                          loginOnTap: uploadImageMethod,
                          isLoginOrSignup: false,
                        ),
                        Icon(
                          imageFile != null ? Icons.check : Icons.close,
                          color: imageFile != null ? Colors.green : Colors.red,
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
                            text: "Add Component",
                            loginOnTap: addComponentMethod,
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
    );
  }
}
