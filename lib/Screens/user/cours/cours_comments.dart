import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class CoursComments extends StatefulWidget {
  final String coursId;
  const CoursComments({Key? key, required this.coursId}) : super(key: key);

  @override
  State<CoursComments> createState() => _CoursCommentsState();
}

class _CoursCommentsState extends State<CoursComments> {
  var user = GetStorage().read('user');
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor1,
          title: Text("Commentaires"),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cours')
                    .doc(widget.coursId)
                    .collection('comments')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, commentSnapshot) {
                  if (commentSnapshot.hasData) {
                    if (commentSnapshot.data!.size != 0) {
                      return ListView.builder(
                        itemCount: commentSnapshot.data!.size,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(commentSnapshot.data!.docs[index].get('owner'))
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                                radius: 33,
                                                backgroundImage: NetworkImage("${userSnapshot.data!.get('profile')}")),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "${userSnapshot.data!.get('name')} ${userSnapshot.data!.get('last_name')}",
                                                            style: TextStyle(color: Colors.white)),
                                                        Spacer(),
                                                        Text(
                                                          "${DateFormat("yyyy/MM/dd hh:mm").format(commentSnapshot.data!.docs[index].get('time').toDate())}",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text("${commentSnapshot.data!.docs[index].get('comment')}",
                                                              style: TextStyle(color: Colors.white)),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Center();
                                      }
                                    }),
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.all(20),
                      );
                    } else
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/message.png',
                              height: Constants.screenHeight * 0.1,
                            ),
                            Text("Pas des commentaires encore.")
                          ],
                        ),
                      );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          onChanged: (value) {},
                          cursorColor: Colors.black,
                          style: TextStyle(
                            height: 1.7,
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(2),
                            filled: true,
                            hintText: "Ecrir une commentaire",
                            fillColor: Colors.cyan.withOpacity(0.2),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(color: Color(0xff00a984), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (!commentController.text.isEmpty) {
                              FirebaseFirestore.instance
                                  .collection('cours')
                                  .doc(widget.coursId)
                                  .collection('comments')
                                  .add({"comment": commentController.text, "time": DateTime.now(), 'owner': user['id']});
                            }
                            commentController.clear();
                          },
                          color: Colors.blueAccent,
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
