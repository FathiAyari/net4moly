import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var role = GetStorage().read("role");
  var user = GetStorage().read("user");
  @override
  void initState() {
    super.initState();
    var timer = Timer(Duration(seconds: 3), () {
      if (role != null) {
        if (role == 'user') {
          Get.toNamed("/user");
        } else {
          Get.toNamed("/admin");
        }
      } else {
        Get.toNamed("/signin");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: Constants.screenHeight,
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.1),
                  child: Text(
                    'Net 4 Moly',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                Lottie.asset(
                  "assets/lotties/education.json",
                  width: Constants.screenWidth,
                ),
                Text(
                  'Nous contribuons à améliorer le monde',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    "assets/lotties/loading.json",
                    height: Constants.screenWidth * 0.2,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
