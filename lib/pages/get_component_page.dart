import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/component_model.dart';
import 'package:robotics_app/models/profile_model.dart';
import 'package:robotics_app/pages/search_page.dart';
import 'package:robotics_app/services/get_component.dart';
import 'package:robotics_app/widgets/component_widget.dart';
import 'package:robotics_app/widgets/moving_logo.dart';

class GetComponentPage extends StatefulWidget {
  const GetComponentPage({
    super.key,
    this.searchText,
    this.isFound,
    required this.profileModel,
  });

  final String? searchText;
  final bool? isFound;
  final ProfileModel profileModel;

  @override
  GetComponentPageState createState() => GetComponentPageState();
}

class GetComponentPageState extends State<GetComponentPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<ComponentModel> components = [];
  List<ComponentModel> paginatedComponents = [];
  int currentPage = 1;
  int itemsPerPage = 25;
  bool showPaginationControls = false; // To toggle pagination visibility

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;

  // Scroll controller for scrolling to the top and detecting scroll position
  final ScrollController _scrollController = ScrollController();

  void onPressedSearchIcon() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(profileModel: widget.profileModel),
      ),
    );
  }

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

    // Load components and initialize pagination
    _loadComponents();

    // Listen to scroll events to toggle pagination visibility
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isBottom =
            _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent;
        setState(() {
          showPaginationControls = isBottom;
        });
      } else {
        setState(() {
          showPaginationControls = false;
        });
      }
    });
  }

  Future<void> _loadComponents() async {
    // print(widget.token);
    // print(await GetHistoryComponent().getHistoryComponent(widget.token));
    // print(
    //   await RequestToBorrow().requestToBorrow(
    //     token: widget.token,
    //     componentId: "67ad3f6684cf1154ac370b7b",
    //   ),
    // );

    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> data = await GetComponents().getComponents();
      print(data);
      components =
          data["data"]
              .map<ComponentModel>((json) => ComponentModel.fromJson(json))
              .toList();
      _updatePaginatedComponents();
    } catch (e) {
      // Handle error
      print("Error loading components: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updatePaginatedComponents() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    setState(() {
      paginatedComponents = components.sublist(
        startIndex,
        endIndex > components.length ? components.length : endIndex,
      );
    });
  }

  void _goToPage(int page) {
    setState(() {
      currentPage = page;
      _updatePaginatedComponents();
    });

    // Scroll to the top of the page
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 900),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _nextPage() {
    if (currentPage * itemsPerPage < components.length) {
      _goToPage(currentPage + 1);
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      _goToPage(currentPage - 1);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Padding(
      //     padding: EdgeInsets.only(bottom: 15.h),
      //     child: Text(
      //       widget.searchText ?? 'Components',
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 32.sp,
      //         fontFamily: "AR Baghdad Font",
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: kPrimarycolor2,
      //   actions: [
      //     IconButton(
      //       onPressed: onPressedSearchIcon,
      //       icon: Icon(Icons.search, color: Colors.white, size: 30.sp),
      //     ),
      //   ],
      // ),
      body:
          isLoading
              ? Center(
                child: MovingLogo(
                  animationController: _animationController,
                  animation: _animation,
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller:
                          _scrollController, // Attach the scroll controller
                      itemCount: paginatedComponents.length,
                      itemBuilder: (context, index) {
                        return ComponentWidget(
                          component: paginatedComponents[index],
                          profileModel: widget.profileModel,
                        );
                      },
                    ),
                  ),
                  if (showPaginationControls) _buildPaginationControls(),
                ],
              ),
    );
  }

  Widget _buildPaginationControls() {
    int totalPages = (components.length / itemsPerPage).ceil();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allow horizontal scrolling
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              tooltip: "Previous Page",
            ),
            ...List.generate(totalPages, (index) {
              int pageNumber = index + 1;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w), // Add spacing
                child: TextButton(
                  onPressed: () => _goToPage(pageNumber),
                  child: Text(
                    pageNumber.toString(),
                    style: TextStyle(
                      color:
                          pageNumber == currentPage
                              ? kOrangeColor
                              : kPrimarycolor1,
                      fontWeight:
                          pageNumber == currentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                      fontSize:
                          pageNumber == currentPage
                              ? 16.sp
                              : 14.sp, // Adjust font size to prevent overflow
                    ),
                  ),
                ),
              );
            }),
            IconButton(
              onPressed: _nextPage,
              icon: const Icon(Icons.arrow_forward),
              tooltip: "Next Page",
            ),
          ],
        ),
      ),
    );
  }
}
