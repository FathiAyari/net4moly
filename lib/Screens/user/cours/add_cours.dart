import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:net4moly/Model/category.dart';
import 'package:net4moly/Model/cours.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class AddCours extends StatefulWidget {
  const AddCours({Key? key}) : super(key: key);

  @override
  State<AddCours> createState() => _AddCoursState();
}

class _AddCoursState extends State<AddCours> {
  bool _isLoading = false;
  List<Category> categories = [
    Category(name: 'Mathématiques', icon: Icons.calculate, id: 1),
    Category(name: 'Science', icon: Icons.science, id: 2),
    Category(name: 'Histoire', icon: Icons.history, id: 3),
    Category(name: 'Langue', icon: Icons.language, id: 4),
    Category(name: 'Technologie', icon: Icons.computer, id: 5),
    Category(name: 'Art', icon: Icons.palette, id: 6),
    Category(name: 'Musique', icon: Icons.music_note, id: 7),
    Category(name: 'Sport', icon: Icons.sports, id: 8),
    Category(name: 'Astronomie', icon: Icons.star, id: 9),
    Category(name: 'Géographie', icon: Icons.map, id: 10),
    Category(name: 'Économie', icon: Icons.monetization_on, id: 11),
  ];

  Category? selectedCategory;
  TextEditingController subjectController = TextEditingController();
  TextEditingController title = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var user = GetStorage().read("user");
  String? _filePath;
  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        title: Text("Ajouter un cours"),
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
                    hintText: "Description de cours",
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
              Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor1,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), width: 1),
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      onPressed: () {
                        getImage();
                      },
                      icon: _filePath == null ? Icon(Icons.picture_as_pdf) : Icon(Icons.done_all),
                      label: Text(_filePath == null ? "Ajouter un fichier pdf" : _filePath!.split("/").last))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: Constants.screenHeight * 0.06,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: DropdownButton<Category>(
                    isExpanded: true,
                    value: selectedCategory,
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Selectionner Catégorie"),
                    ),
                    underline: SizedBox(
                      height: 0,
                    ),
                    items: categories.map<DropdownMenuItem<Category>>((Category category) {
                      return DropdownMenuItem<Category>(
                        key: Key(category.id.toString()),
                        value: category,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(category.name),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
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
                            if (_formKey.currentState!.validate() && selectedCategory != null) {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_filePath != null) {
                                var image = FirebaseStorage.instance.ref(_filePath);
                                var task = image.putFile(File(_filePath!));
                                var imageUrl = await (await task).ref.getDownloadURL();
                                FirebaseFirestore.instance.collection("cours").add(Cours(
                                        owner: user['id'],
                                        file: imageUrl,
                                        categoryId: selectedCategory!.id,
                                        savedFor: [],
                                        title: title.text,
                                        likes: [],
                                        creationDate: DateTime.now(),
                                        description: subjectController.text)
                                    .Tojson());
                              } else {
                                FirebaseFirestore.instance.collection("cours").add(Cours(
                                        owner: user['id'],
                                        likes: [],
                                        categoryId: selectedCategory!.id,
                                        file: "",
                                        savedFor: [],
                                        title: title.text,
                                        creationDate: DateTime.now(),
                                        description: subjectController.text)
                                    .Tojson());
                              }
                              final snackBar = SnackBar(
                                content: const Text('Cours ajouté avec success'),
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
                                _filePath = null;
                              });
                            } else {
                              final snackBar = SnackBar(
                                content: const Text('Categorie obligatoire'),
                                backgroundColor: (Colors.red),
                                action: SnackBarAction(
                                  label: 'fermer',
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
