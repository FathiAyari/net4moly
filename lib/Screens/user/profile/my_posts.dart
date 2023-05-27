import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:net4moly/Model/post.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Screens/user/posts/edit_post.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';
import 'package:readmore/readmore.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  ScrollController _controller = ScrollController();
  var user = GetStorage().read("user");

  void showMenuItems(BuildContext context, String postId) async {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    final result = await showMenu(
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      context: context,
      items: [
        PopupMenuItem(
          onTap: () {},
          value: 'delete',
          child: Text('Suprrimer'),
        ),
        PopupMenuItem(
          onTap: () {},
          value: 'edit',
          child: Text('Modifier'),
        ),
      ],
    );

    if (result != null) {
      if (result == 'delete') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Supprimer"),
              content: Text("êtes-vous sûr de vouloir suprimer cet élément?"),
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
                  child: Text("Oui"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    FirebaseFirestore.instance.collection('posts').doc(postId).delete();
                    var test = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').get();
                    for (var data in test.docs.toList()) {
                      data.reference.delete();
                    }
                  },
                ),
              ],
            );
          },
        );
      } else if (result == 'edit') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPost(
                      postId: postId,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        title: Text("Mes publications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("creationDate", descending: true)
            .where("owner", isEqualTo: user['id'])
            .snapshots(),
        builder: (context, postsSnapshots) {
          if (postsSnapshots.hasData) {
            if (postsSnapshots.data!.size != 0) {
              return RawScrollbar(
                thumbColor: Colors.blueAccent,
                controller: _controller,
                isAlwaysShown: true,
                radius: Radius.circular(20),
                child: ListView.builder(
                    controller: _controller,
                    itemCount: postsSnapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      List<Post> postslists = [];
                      var listOfData = postsSnapshots.data!.docs.toList();

                      for (var center in listOfData) {
                        postslists.add(Post.fromJson(center.data() as Map<String, dynamic>));
                      }
                      return Padding(
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
                                  stream: FirebaseFirestore.instance.collection("users").doc(postslists[index].owner).snapshots(),
                                  builder:
                                      (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        onTap: () {},
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
                                                      Text(
                                                          "${DateFormat("yyyy-MM-dd hh:mm").format(postslists[index].creationDate)}"),
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
                                                  showMenuItems(context, postsSnapshots.data!.docs[index].id);
                                                },
                                                icon: Icon(Icons.more_vert))
                                          ],
                                        ),
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
                                                '${postslists[index].description}',
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
                                  if (postslists[index].image!.isNotEmpty) ...[
                                    Container(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network(
                                              "${postslists[index].image}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: OutlinedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              width: 2.0,
                                              color: postslists[index].likes.contains(user['id']) ? Colors.red : Colors.grey,
                                            ),
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            List oldData = postslists[index].likes;
                                            if (oldData.contains(user['id'])) {
                                              oldData.remove(user['id']);
                                            } else {
                                              oldData.add(user['id']);
                                            }
                                            postsSnapshots.data!.docs[index].reference.update({'likes': oldData});
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: postslists[index].likes.contains(user['id']) ? Colors.red : Colors.grey,
                                          ),
                                          label: Text(
                                            '${postslists[index].likes.length}',
                                            style: TextStyle(
                                              color: postslists[index].likes.contains(user['id']) ? Colors.red : Colors.grey,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: OutlinedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(width: 2.0, color: Colors.indigo),
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Get.to(Comments(postId: postsSnapshots.data!.docs[index].id));
                                        },
                                        icon: Icon(Icons.comment, color: Colors.indigo),
                                        label: StreamBuilder<QuerySnapshot>(
                                          builder: (context, snapshpt) {
                                            if (snapshpt.hasData) {
                                              return Text("${snapshpt.data!.size}", style: TextStyle(color: Colors.indigo));
                                            } else {
                                              return Text("");
                                            }
                                          },
                                          stream: FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(postsSnapshots.data!.docs[index].id)
                                              .collection('comments')
                                              .snapshots(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: OutlinedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              width: 2.0,
                                              color: postslists[index].savedFor.contains(user['id'])
                                                  ? AppColors.mainColor1
                                                  : Colors.grey,
                                            ),
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            List oldData = postslists[index].savedFor;
                                            if (oldData.contains(user['id'])) {
                                              oldData.remove(user['id']);
                                            } else {
                                              oldData.add(user['id']);
                                            }
                                            postsSnapshots.data!.docs[index].reference.update({'savedFor': oldData});
                                          },
                                          icon: Icon(
                                            Icons.save_alt,
                                            color: postslists[index].savedFor.contains(user['id'])
                                                ? AppColors.mainColor1
                                                : Colors.grey,
                                          ),
                                          label: Text("")),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
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
                        child: Text("Pas des publications pour le moment "),
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
