// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:robotics_app/colors.dart';
// import 'package:robotics_app/widgets/custom_text_field.dart';

// class BorrowComponentPage extends StatelessWidget {
//   BorrowComponentPage({super.key});
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController componentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height / 4.4,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(25.r),
//                 bottomLeft: Radius.circular(25.r),
//               ),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [kPrimarycolor1, kPrimarycolor2],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(27.sp),
//                   child: Text(
//                     "Metaphor",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 35.sp,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: "AR Baghdad Font",
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       width: 120.w,
//                       height: 25.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(25.r),
//                       ),
//                     ),
//                     Container(
//                       width: 120.w,
//                       height: 25.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(25.r),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 150.h),

//             child: Column(
//               children: [
//                 CustomTextField(
//                   controller: nameController,
//                   hintText: "Name",
//                   isComponentPage: true,
//                 ),
//                 SizedBox(height: 75.h),
//                 CustomTextField(
//                   controller: componentController,
//                   hintText: "Component",
//                   isComponentPage: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/borrowed_component_model.dart';
import 'package:robotics_app/services/get_borrowed_component.dart';
import 'package:robotics_app/widgets/moving_logo.dart';
import 'package:robotics_app/widgets/requested_Borrowed_components_widget.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class BorrowComponentPage extends StatefulWidget {
  const BorrowComponentPage({super.key, required this.token});
  final String token;

  @override
  State<BorrowComponentPage> createState() => _BorrowComponentPageState();
}

class _BorrowComponentPageState extends State<BorrowComponentPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  // Animation controller
  late AnimationController _animationController;

  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: GetBorrowedComponent().getBorrowedComponent(
          token: widget.token,
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
          } else if (snapshot.data!["data"].isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaticLogo(isBlueLogo: true),

                  Text(
                    "No Borrowed Components",
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
            return ListView.builder(
              itemCount: snapshot.data!["data"].length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: RequestedBorrowedComponentsWidget(
                    borrowedComponent: BorrowedComponentModel.fromJson(
                      snapshot.data!["data"][index],
                    ),
                    token: widget.token,
                    isBorrowedWidget: true,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
