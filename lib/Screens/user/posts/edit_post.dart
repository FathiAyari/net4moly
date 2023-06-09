import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:net4moly/Model/post.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class EditPost extends StatefulWidget {
  final String postId;
  const EditPost({Key? key, required this.postId}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostData();
  }

  getPostData() async {
    var post = await FirebaseFirestore.instance.collection("posts").doc(widget.postId).get();
    Post postData = Post.fromJson(post.data() as Map<String, dynamic>);
    setState(() {
      subjectController.text = postData.description;
      title.text = postData.title;
      imageUrl = postData.image != null ? postData.image! : '';
    });
  }

  bool _isLoading = false;
  String imageUrl = '';
  TextEditingController subjectController = TextEditingController();
  TextEditingController title = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var user = GetStorage().read("user");
  File? _image;
  Future getPostImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        title: Text("Modifier une publication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: title,
                  keyboardType: TextInputType.visiblePassword,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(
                    color: AppColors.mainColor1,
                    fontFamily: "Helvetica",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Champ obligatoire";
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintText: 'Titre',
                    hintStyle: TextStyle(
                      color: AppColors.mainColor1,
                      fontFamily: "Helvetica",
                    ),
                    contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 20, right: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.mainColor1,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.mainColor1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Champ obligatoire";
                    }
                  },
                  controller: subjectController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: AppColors.mainColor1,
                      fontFamily: "Helvetica",
                    ),
                    hintText: "Sujet de publication",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.mainColor1,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.mainColor1,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  getPostImage();
                },
                child: Padding(
                  padding: EdgeInsets.all(Constants.screenHeight * 0.03),
                  child: Container(
                    height: Constants.screenHeight * 0.1,
                    child: imageUrl != ''
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.fill,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    imageUrl = "";
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              )
                            ],
                          )
                        : _image == null
                            ? Image.asset("assets/images/gallery.png")
                            : Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 60),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), width: 1),
                          borderRadius: BorderRadius.circular(40)),
                      primary: AppColors.mainColor1.withOpacity(1),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(210, 255, 255, 255)),
                            ),
                          )
                        : const Text(
                            'Ajouter',
                            style: TextStyle(fontSize: 20, fontFamily: "TodaySB", color: Colors.white),
                          ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_image != null) {
                                var image = FirebaseStorage.instance.ref(_image!.path);
                                var task = image.putFile(_image!);
                                var imgValue = await (await task).ref.getDownloadURL();
                                FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(widget.postId)
                                    .update({"image": imgValue, "title": title.text, "description": subjectController.text});
                              } else {
                                FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(widget.postId)
                                    .update({"title": title.text, "description": subjectController.text});
                              }
                              final snackBar = SnackBar(
                                content: const Text('Publication modifié avec success'),
                                backgroundColor: (Colors.green),
                                action: SnackBarAction(
                                  label: 'fermer',
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setState(() {
                                _isLoading = false;
                                title.clear();
                                subjectController.clear();
                                _image = null;
                              });
                            }
                          }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
