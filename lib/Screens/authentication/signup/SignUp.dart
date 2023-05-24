import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:net4moly/Model/user.dart';
import 'package:net4moly/Screens/authentication/signin/sign_in.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Services/AuthServices.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController birth_date = TextEditingController();
  TextEditingController phone_number = TextEditingController();
  TextEditingController email = TextEditingController();
  bool _isObscure = true;
  File? _image;
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future getProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background.jpg"),
            )),
          ),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      width: 100,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  _image == null ? AssetImage('assets/images/profile.png') as ImageProvider : FileImage(_image!),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.indigo,
                              radius: 20,
                              child: IconButton(
                                  onPressed: () {
                                    getProfileImage();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        controller: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire";
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                              fontFamily: "Helvetica",
                            ),
                            hintText: "Entrez votre prénom",
                            fillColor: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        controller: last_name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire";
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                              fontFamily: "Helvetica",
                            ),
                            hintText: "Entrez votre nom de famille",
                            fillColor: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire";
                          }
                        },
                        controller: birth_date,
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                              fontFamily: "Helvetica",
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ), // icon is 48px widget.
                            ),
                            hintText: "Date de naissance",
                            fillColor: Colors.white.withOpacity(0.1)),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1920),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.white,
                                      onPrimary: AppColors.mainColor1,
                                      surface: Colors.white,
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: AppColors.mainColor1,
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: Color.fromARGB(255, 189, 228, 211),
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              });
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
                            setState(() {
                              birth_date.text = formattedDate;
                            });
                          }
                        }, //set
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire";
                          }
                        },
                        controller: phone_number,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
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
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                                fontFamily: "Helvetica", color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)),
                            hintText: "Entrez votre numéro de téléphone",
                            fillColor: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire";
                          } else {
                            bool emailValid =
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                            if (!emailValid) {
                              return "Format d'email invalide ";
                            }
                          }
                        },
                        controller: email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica",
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                              fontFamily: "Helvetica",
                            ),
                            hintText: "Entrer votre Email",
                            fillColor: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire";
                          }
                          if (value.length < 8) {
                            return 'Mot de passe doit plus de 8 caracteres';
                          }
                        },
                        obscureText: _isObscure,
                        controller: password,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.white,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica",
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Tapez votre mot de passe',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                              fontFamily: "Helvetica",
                            ),
                            contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 20, right: 15),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                  color: Colors.white.withOpacity(0.5),
                                  icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            )),
                        onChanged: (value) {
                          //Do something
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(100, 60),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                primary: AppColors.mainColor1.withOpacity(1),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate() && _image != null) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        var image = FirebaseStorage.instance // instance
                                            .ref(_image!.path); //ref=> esm de fichier fel storage
                                        var task = image.putFile(_image!);
                                        var imageUrl =
                                            await (await task) // await 1: attendre l'upload d'image dans firestorage,2await: attendre la recuperation de lien getDownloadURL
                                                .ref
                                                .getDownloadURL();
                                        bool check = await AuthServices().signUp(AppUser(
                                            name: name.text,
                                            profile: imageUrl,
                                            last_name: last_name.text,
                                            birth_date: birth_date.text,
                                            phone_number: phone_number.text,
                                            email: email.text,
                                            password: password.text,
                                            role: "user"));

                                        if (check) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          AuthServices().getUserData().then((value) {
                                            AuthServices().saveUserLocally(value);

                                            if (value.role == 'user') {
                                              Navigator.pushNamed(context, "/user");
                                            } else {
                                              Navigator.pushNamed(context, "/admin");
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          final snackBar = SnackBar(
                                            content: const Text('ce mail est déja utilisé'),
                                            backgroundColor: (Colors.red),
                                            action: SnackBarAction(
                                              label: 'fermer',
                                              textColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      } else if (_image == null) {
                                        final snackBar = SnackBar(
                                          content: const Text('Image obligatoire'),
                                          backgroundColor: (Colors.red),
                                          action: SnackBarAction(
                                            label: 'fermer',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    },
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
                                      "S'inscrire",
                                      style: TextStyle(fontSize: 20, fontFamily: "TodaySB", color: Colors.white),
                                    ))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Vous avez un compte?',
                          style: TextStyle(fontSize: 15, fontFamily: "Helvetica", color: Colors.white),
                        ),
                        TextButton(
                          child: const Text(
                            "S'identifier",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Helvetica",
                                decoration: TextDecoration.underline,
                                color: Color.fromARGB(155, 255, 255, 255)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signin()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
