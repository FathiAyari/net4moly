import 'dart:io';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/cours/cours_screen.dart';
import 'package:net4moly/Screens/user/messages/Messages.dart';
import 'package:net4moly/Screens/user/posts/posts.dart';
import 'package:net4moly/Screens/user/saved_content/saved_content.dart';

import 'profile/profile_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Widget> pages = [Posts(), CoursScreen(), SavedContent(), buildMessages(), ProfileScreen()];
  int index = 0;
  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("vous etes sur de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: SafeArea(
        child: Scaffold(
          body: pages[index],
          bottomNavigationBar: CustomNavigationBar(
            currentIndex: index,
            bubbleCurve: Curves.bounceIn,
            scaleCurve: Curves.decelerate,
            selectedColor: AppColors.mainColor1,
            unSelectedColor: AppColors.mainColor1.withOpacity(0.8),
            strokeColor: AppColors.mainColor1,
            scaleFactor: 0.5,
            iconSize: 30,
            onTap: (val) {
              setState(() {
                index = val;
              });
            },
            backgroundColor: Colors.white,
            items: [
              CustomNavigationBarItem(icon: Icon(Icons.home)),
              CustomNavigationBarItem(icon: Icon(Icons.article)),
              CustomNavigationBarItem(icon: Icon(Icons.bookmark_add)),
              CustomNavigationBarItem(icon: Icon(Icons.message)),
              CustomNavigationBarItem(
                icon: Icon(Icons.person),
              )
            ],
          ),
        ),
      ),
    );
  }
}
