import 'dart:io';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net4moly/Screens/admin/profile.dart';
import 'package:net4moly/Screens/admin/reports.dart';
import 'package:net4moly/Screens/admin/users.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/messages/Messages.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Widget> pages = [ AllUsers(),Reports(), buildMessages(), AdminProfile()];
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
              CustomNavigationBarItem(icon: Icon(Icons.account_circle_outlined)),
              CustomNavigationBarItem(icon: Icon(Icons.warning)),
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
