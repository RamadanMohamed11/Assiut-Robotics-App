import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/component_model.dart';
import 'package:robotics_app/models/requested_component_model.dart';
import 'package:robotics_app/services/get_requested_component.dart';
import 'package:robotics_app/widgets/moving_logo.dart';
import 'package:robotics_app/widgets/requested_Borrowed_components_widget.dart';
import 'package:robotics_app/widgets/static_logo.dart';

class RequestedComponentsPage extends StatefulWidget {
  const RequestedComponentsPage({super.key, required this.token});

  final String token;

  @override
  State<RequestedComponentsPage> createState() =>
      _RequestedComponentsPageState();
}

class _RequestedComponentsPageState extends State<RequestedComponentsPage>
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
        future: GetRequestedComponent().getRequestedComponent(widget.token),
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
                    "No Requested Components",
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
                    requestComponent: RequestedComponentModel.fromJson(
                      snapshot.data!["data"][index],
                    ),
                    token: widget.token,
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
