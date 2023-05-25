import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:net4moly/Model/user.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/messages/Messenger.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class Admins extends StatefulWidget {
  const Admins({Key? key}) : super(key: key);

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        title: Text("Les admins"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'admin')
                  .where("id", isNotEqualTo: user['id'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.size != 0) {
                    List<AppUser> admins = [];
                    for (var user in snapshot.data!.docs.toList()) {
                      admins.add(AppUser.fromJson(user.data()));
                    }
                    return ListView.builder(
                        itemCount: admins.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              height: Constants.screenHeight * 0.1,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.indigo.withOpacity(0.5)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(admins[index].profile),
                                      radius: 40,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${admins[index].name} ${admins[index].last_name}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        admins[index].email,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(Messenger(
                                                user: AppUser(
                                                    id: admins[index].id,
                                                    name: admins[index].name,
                                                    email: admins[index].email,
                                                    last_name: admins[index].last_name,
                                                    role: admins[index].role,
                                                    profile: admins[index].profile)));
                                          },
                                          child: Image.asset('assets/images/chat.png', height: Constants.screenHeight * 0.05),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Container(
                        height: Constants.screenHeight * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Pas d'admin diponible pour le moment "),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
