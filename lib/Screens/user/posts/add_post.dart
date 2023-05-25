import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:net4moly/Model/post.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool _isLoading = false;

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
        title: Text("Ajouter une publication"),
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
                    height: Constants.screenHeight * 0.09,
                    child: _image == null
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
                                var imageUrl = await (await task).ref.getDownloadURL();
                                FirebaseFirestore.instance.collection("posts").add(Post(
                                        owner: user['id'],
                                        image: imageUrl,
                                        savedFor: [],
                                        title: title.text,
                                        likes: [],
                                        creationDate: DateTime.now(),
                                        description: subjectController.text)
                                    .Tojson());
                              } else {
                                FirebaseFirestore.instance.collection("posts").add(Post(
                                        owner: user['id'],
                                        likes: [],
                                        image: "",
                                        savedFor: [],
                                        title: title.text,
                                        creationDate: DateTime.now(),
                                        description: subjectController.text)
                                    .Tojson());
                              }
                              final snackBar = SnackBar(
                                content: const Text('Publication ajouté avec success'),
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
