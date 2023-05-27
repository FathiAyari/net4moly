import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:net4moly/Screens/admin/report.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';
import 'package:readmore/readmore.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("reports").snapshots(),
        builder: (context, postsSnapshots) {
          if (postsSnapshots.hasData) {
            if (postsSnapshots.data!.size != 0) {
              return ListView.builder(
                  itemCount: postsSnapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    List<ReportModel> postslists = [];
                    var listOfData = postsSnapshots.data!.docs.toList();

                    for (var center in listOfData) {
                      postslists.add(ReportModel.fromJson(center.data() as Map<String, dynamic>));
                    }
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("posts").doc(postslists[index].postId).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> pstSnapshot) {
                          if (pstSnapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration:
                                    BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                                          child: Text("Sujet de signale : ${postslists[index].subject}"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                                          child: Text(
                                              "Date de signale : ${DateFormat("yyyy-MM-dd hh:mm").format(postslists[index].date)}"),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.red,
                                      thickness: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(pstSnapshot.data!.get("owner"))
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                          if (snapshot.hasData) {
                                            return Row(
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "${snapshot.data!.get("name")} ${snapshot.data!.get("last_name")}"),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "${DateFormat("yyyy-MM-dd hh:mm").format(pstSnapshot.data!.get("creationDate").toDate())}"),
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
                                                IconButton(
                                                    onPressed: () {
                                                      // Show the dialog
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Supprimer"),
                                                            content: Text("êtes-vous sûr de vouloir supprimer cet élément?"),
                                                            actions: [
                                                              // Define the actions that the user can take
                                                              TextButton(
                                                                child: Text("Annuler"),
                                                                onPressed: () {
                                                                  // Close the dialog
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  "Restaurer",
                                                                  style: TextStyle(color: Colors.green),
                                                                ),
                                                                onPressed: () {
                                                                  postsSnapshots.data!.docs[index].reference.delete();
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  "Supprimer",
                                                                  style: TextStyle(color: Colors.red),
                                                                ),
                                                                onPressed: () async {
                                                                  var test = await FirebaseFirestore.instance
                                                                      .collection('posts')
                                                                      .doc(pstSnapshot.data!.reference.id)
                                                                      .collection('comments')
                                                                      .get();
                                                                  for (var data in test.docs.toList()) {
                                                                    data.reference.delete();
                                                                  }
                                                                  postsSnapshots.data!.docs[index].reference.delete();
                                                                  pstSnapshot.data!.reference.delete();
                                                                  Navigator.of(context).pop();
                                                                  final snackBar = SnackBar(
                                                                    content: const Text('Vous avez supprimé ce publication'),
                                                                    backgroundColor: (Colors.red),
                                                                    action: SnackBarAction(
                                                                      label: 'fermer',
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(Icons.more_vert)),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ReadMoreText(
                                                      '${pstSnapshot.data!.get("description")}',
                                                      trimLines: 2,
                                                      style: TextStyle(color: Colors.black),
                                                      colorClickableText: Colors.pink,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText: '...voir plus',
                                                      trimExpandedText: ' reduire ',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (pstSnapshot.data!.get("image")!.isNotEmpty) ...[
                                          Container(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Image.network(
                                                    "${pstSnapshot.data!.get("image")}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        });
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
                        child: Text("Pas des publications signlés pour le moment "),
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
    );
  }
}
