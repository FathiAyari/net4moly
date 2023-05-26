import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:net4moly/Model/user.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/contact_admin/admins.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

import '../../chatbot/chat_screen.dart';
import 'Messenger.dart';

class buildMessages extends StatefulWidget {
  @override
  _buildMessagesState createState() => _buildMessagesState();
}

class _buildMessagesState extends State<buildMessages> {
  var user = GetStorage().read("user");
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: SpeedDial(
          backgroundColor: AppColors.mainColor1,
          icon: Icons.mark_chat_read,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(
              child: Icon(Icons.admin_panel_settings_outlined),
              label: 'Service Client',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Admins()));
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.person_3),
              label: 'Assistance',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const ProviderScope(child: ChatScreen()),
                    ));
              },
            ),
          ],
        ),

        /*  floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Admins()));
          },
          backgroundColor: AppColors.mainColor1,
          child: Icon(Icons.admin_panel_settings_outlined),
        ),*/

        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: snapshotMessages
                    .collection('messages')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  List msg = [];

                  if (snapshot.hasData) {
                    if (snapshot.data!.size != 0) {
                      final messages = snapshot.data!.docs.reversed;

                      for (var message in messages) {
                        final getText = message.get('text');
                        final getSender = message.get('sender');
                        final getDestination = message.get('destination');
                        final getTime = message.get('time');
                        final Map<String, String> messageWidget = {
                          'getText': getText,
                          'getTime': DateFormat('kk:mm').format(
                              DateTime.parse(getTime.toDate().toString())),
                          'getSender': getSender,
                          'getDestination': getDestination,
                        };
                        if ((((messageWidget["getSender"] == user['id']) ||
                            (messageWidget["getDestination"] == user['id'])))) {
                          msg.add(messageWidget);
                        }
                      }

                      for (int i = 0; i < msg.length; i++) {
                        for (int j = i + 1; j < msg.length; j++) {
                          if ((msg[i]["getSender"] == msg[j]["getSender"]) &&
                                  (msg[i]["getDestination"] ==
                                      msg[j]["getDestination"]) ||
                              (msg[i]["getSender"] ==
                                      msg[j]["getDestination"]) &&
                                  (msg[i]["getSender"] ==
                                      msg[j]["getDestination"])) {
                            msg[j] = {
                              'getText': '',
                              'getSender': '',
                              'getDestination': '',
                            };
                          }
                        }
                      }

                      for (int i = 0; i < msg.length; i++) {
                        if (msg[i]["getSender"] == "") {
                          msg.remove(msg[i]);
                          i--;
                        }
                      }
                      if (msg.isNotEmpty) {
                        return Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount: msg.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.cyan.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InkWell(
                                      onTap: () async {
                                        var destination =
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .where(
                                                  "id",
                                                  isEqualTo: this.user['id'] ==
                                                          msg[index]
                                                              ["getDestination"]
                                                      ? "${msg[index]["getSender"]}"
                                                      : "${msg[index]["getDestination"]}",
                                                )
                                                .get();
                                        var user = AppUser.fromJson(destination
                                            .docs
                                            .toList()
                                            .first
                                            .data() as Map<String, dynamic>);

                                        Get.to(Messenger(
                                          user: user,
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: msg[index]['getSender'] ==
                                                    user['id']
                                                ? FirebaseFirestore.instance
                                                    .collection("users")
                                                    .where('id',
                                                        isEqualTo: msg[index]
                                                            ["getDestination"])
                                                    .snapshots()
                                                : FirebaseFirestore.instance
                                                    .collection("users")
                                                    .where('id',
                                                        isEqualTo: msg[index]
                                                            ["getSender"])
                                                    .snapshots(),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.hasData) {
                                                return Row(
                                                  children: [
                                                    CircleAvatar(
                                                        radius: 33,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                "${snapshot.data!.docs[0].get('profile')}")),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${snapshot.data!.docs[0].get('name')} ${snapshot.data!.docs[0].get('last_name')}",
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    "${msg[index]['getSender'] == user['id'] ? 'Vous ' : ''} ${msg[index]["getText"]}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      "${msg[index]["getTime"]}"),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            }),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(20),
                              controller: controller,
                            )),
                          ],
                        );
                      } else {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/message.png',
                                height: Constants.screenHeight * 0.1,
                              ),
                              Text("Pas des messages encore.")
                            ],
                          ),
                        );
                      }
                    } else
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/message.png',
                              height: Constants.screenHeight * 0.1,
                            ),
                            Text("Pas des messages encore.")
                          ],
                        ),
                      );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
