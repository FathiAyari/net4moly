import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/profile/change_email.dart';
import 'package:net4moly/Screens/user/profile/change_name.dart';
import 'package:net4moly/Screens/user/profile/change_password.dart';
import 'package:net4moly/Screens/user/profile/my_posts.dart';
import 'package:net4moly/Services/AuthServices.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage("${user['profile']} "),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user['name']} ${user['last_name']}",
                      style: TextStyle(fontSize: Constants.screenHeight * 0.03),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            " ${user['email']}",
                            style: TextStyle(fontSize: Constants.screenHeight * 0.02),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Get.to(ChangeEmail());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                  height: Constants.screenHeight * 0.1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "changer votre mail",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(ChangePassword());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                  height: Constants.screenHeight * 0.1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "changer votre mot de passe",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(ChangeName());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                  height: Constants.screenHeight * 0.1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "changer votre nom et prénom",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(MyPosts());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                  height: Constants.screenHeight * 0.1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Mes publications",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Get.to(MyPosts());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                  height: Constants.screenHeight * 0.1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Mes Cours",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Deconnecter"),
                      content: Text("êtes-vous sûr de vouloir deconnecter?"),
                      actions: [
                        // Define the actions that the user can take
                        TextButton(
                          child: Text("Annuler"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Oui"),
                          onPressed: () async {
                            AuthServices().logOut(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.mainColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                  height: Constants.screenHeight * 0.1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Deconnecter",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
