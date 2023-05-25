import 'package:flutter/material.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/saved_content/my_saved_cours.dart';
import 'package:net4moly/Screens/user/saved_content/my_saved_posts.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class SavedContent extends StatefulWidget {
  const SavedContent({Key? key}) : super(key: key);

  @override
  State<SavedContent> createState() => _SavedContentState();
}

class _SavedContentState extends State<SavedContent> with TickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)..addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.04),
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              height: Constants.screenHeight * 0.06,
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                splashFactory: NoSplash.splashFactory,
                labelColor: AppColors.mainColor1,
                controller: _tabController,
                labelPadding: EdgeInsets.all(10),
                indicator: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                tabs: [
                  Container(
                      alignment: Alignment.center,
                      child: Text("Publications", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                  Container(
                      alignment: Alignment.center,
                      child: Text("Cours", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                ],
              ),
            ),
          ),
          Expanded(
              child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [MySavedPosts(), MySavedCours()],
          ))
        ],
      ),
    );
  }
}
