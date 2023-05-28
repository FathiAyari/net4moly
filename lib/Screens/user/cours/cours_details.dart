import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:net4moly/Model/cours.dart';
import 'package:net4moly/Model/user.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/messages/Messenger.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class CoursDetails extends StatefulWidget {
  final Cours cours;
  const CoursDetails({Key? key, required this.cours}) : super(key: key);

  @override
  State<CoursDetails> createState() => _CoursDetailsState();
}

class _CoursDetailsState extends State<CoursDetails> {
  var user = GetStorage().read('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        title: Text("Details de cours"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(widget.cours.owner).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () {
                          if (user['id'] != snapshot.data!.get("id")) {
                            Get.to(Messenger(
                              user: AppUser(
                                  name: snapshot.data!.get("name"),
                                  id: snapshot.data!.get("id"),
                                  profile: snapshot.data!.get("profile"),
                                  last_name: snapshot.data!.get("profile"),
                                  email: snapshot.data!.get("email"),
                                  role: snapshot.data!.get("role")),
                            ));
                          }
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: Constants.screenHeight * 0.033,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage("${snapshot.data!.get("profile")}"),
                                radius: Constants.screenHeight * 0.030,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${snapshot.data!.get("name")} ${snapshot.data!.get("last_name")}"),
                                  Row(
                                    children: [
                                      Text("${DateFormat("yyyy-MM-dd hh:mm").format(widget.cours.creationDate)}"),
                                      Icon(
                                        Icons.access_time_sharp,
                                        size: Constants.screenHeight * 0.02,
                                        color: Colors.blueAccent,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.cours.title}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.cours.description}',
                      ),
                      if (widget.cours.file!.isNotEmpty)
                        Expanded(
                          child: PDF(
                            onError: (error) {},
                          ).cachedFromUrl(widget.cours.file!),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
