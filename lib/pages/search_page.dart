import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robotics_app/colors.dart';
import 'package:robotics_app/models/component_model.dart';
import 'package:robotics_app/services/get_component.dart';
import 'package:robotics_app/widgets/component_widget.dart';
import 'package:robotics_app/widgets/custom_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.token});

  final String token;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final StreamController<List<ComponentModel>> _streamController =
      StreamController<List<ComponentModel>>();
  List<ComponentModel> allComponents = [];

  @override
  void initState() {
    super.initState();
    _loadComponents();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    _streamController.close();
    super.dispose();
  }

  Future<void> _loadComponents() async {
    // Load all components initially
    Map<String, dynamic> data = await GetComponents().getComponents();
    allComponents =
        data["data"]
            .map<ComponentModel>((json) => ComponentModel.fromJson(json))
            .toList();
    _streamController.add(allComponents); // Add all components to the stream
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    List<ComponentModel> filteredComponents =
        allComponents
            .where(
              (component) => component.title.toLowerCase().contains(query),
            ) // Filter by title
            .toList();
    _streamController.add(filteredComponents); // Update the stream
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            "Search Components",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontFamily: "AR Baghdad Font",
            ),
          ),
        ),
        backgroundColor: kPrimarycolor2,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Make back arrow white
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
            CustomTextField(
              controller: searchController,
              hintText: "Search",
              isComponentPage: true,
            ),
            SizedBox(height: 25.h),
            Expanded(
              child: StreamBuilder<List<ComponentModel>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No components found",
                        style: TextStyle(color: Colors.red, fontSize: 18.sp),
                      ),
                    );
                  }
                  List<ComponentModel> components = snapshot.data!;
                  return ListView.builder(
                    itemCount: components.length,
                    itemBuilder: (context, index) {
                      return ComponentWidget(
                        component: components[index],
                        token: widget.token,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
