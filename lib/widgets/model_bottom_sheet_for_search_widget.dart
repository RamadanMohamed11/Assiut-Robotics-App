// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:robotics_app/colors.dart';
// import 'package:robotics_app/helper/transitions.dart';
// import 'package:robotics_app/pages/get_component_page.dart';
// import 'package:robotics_app/services/get_component.dart';
// import 'package:robotics_app/widgets/custom_text_field.dart';

// class ModelBottomSheetForSearchWidget extends StatefulWidget {
//   const ModelBottomSheetForSearchWidget({super.key});

//   @override
//   State<ModelBottomSheetForSearchWidget> createState() =>
//       _ModelBottomSheetForSearchWidgetState();
// }

// class _ModelBottomSheetForSearchWidgetState
//     extends State<ModelBottomSheetForSearchWidget> {
//   final TextEditingController searchController = TextEditingController();
//   String searchText = "";

//   // void searchOnSavedMethod(String? value) {
//   //   searchText = value!;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: 8,
//           right: 8,
//           bottom:
//               MediaQuery.of(
//                 context,
//               ).viewInsets.bottom, // Adjust for the keyboard
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 50),
//             CustomTextField(controller: searchController, hintText: "Search"),
//             const SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: InkWell(
//                 onTap: () async {
//                   Map<String, dynamic> data =
//                       await GetComponents().getComponents();
//                   if (searchController.text.isNotEmpty) {
//                     bool isFound = false;
//                     for (int i = 0; i < data["data"].length; i++) {
//                       if (data["data"][i]["title"] == searchController.text) {
//                         isFound = true;
//                         break;
//                       }
//                     }

//                     if (!mounted) return;
//                     if (!mounted) return;
//                     if (mounted) {
//                       Navigator.push(
//                         context,
//                         CustomScaleTransition(
//                           GetComponentPage(
//                             searchText: searchController.text,
//                             isFound: isFound,
//                           ),
//                           alignment: Alignment.topCenter,
//                         ),
//                       );
//                     }
//                     searchController.clear();
//                   }
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: kPrimarycolor2,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Search For Component",
//                       style: TextStyle(color: Colors.white, fontSize: 24.sp),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//           ],
//         ),
//       ),
//     );
//   }
// }
