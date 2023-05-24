import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net4moly/Screens/authentication/reset_password/Forgot_password.dart';
import 'package:net4moly/Screens/authentication/signup/SignUp.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Services/AuthServices.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';

class Signin extends StatefulWidget {
  bool firstLogin = true;

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool selected = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String email;
  late String password;
  bool loginFormVisible = false;
  bool _isObscure = true;
  var logoWidth = 110.0;
  var logoHeight = 136.0;
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("vous etes sur de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => avoidReturnButton(),
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background.jpg"),
            )),
          ),
          Form(
            key: _formKey,
            child: ListView(shrinkWrap: true, children: <Widget>[
              Image.asset(
                "assets/images/logo_white.png",
                height: Constants.screenHeight * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Champ obligatoire";
                    }
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Helvetica",
                  ),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'Entrer votre Email',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                        fontFamily: "Helvetica",
                      ),
                      contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 20, right: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
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
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      )),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: TextFormField(
                  obscureText: _isObscure,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Colors.white,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(
                    color: Colors.white,
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
                      hintText: 'Tapez votre mot de passe',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                        fontFamily: "Helvetica",
                      ),
                      contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 20, right: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
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
                        borderRadius: BorderRadius.circular(15),
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
                    value = passwordController.text;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    child: TextButton(
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Helvetica", decoration: TextDecoration.underline, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Forgot(),
                      ),
                    );
                  },
                )),
              ),
              const SizedBox(
                width: 30,
                height: 30,
              ),
              Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(90, 0, 80, 0),
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
                              'Connecter',
                              style: TextStyle(fontSize: 20, fontFamily: "TodaySB", color: Colors.white),
                            ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                AuthServices().signIn(emailController.text, passwordController.text).then((value) async {
                                  if (value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    AuthServices().getUserData().then((value) {
                                      AuthServices().saveUserLocally(value);
                                      if (value.role == 'client') {
                                        Navigator.pushNamed(context, "/user");
                                      } else {
                                        Get.toNamed("/admin");
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    final snackBar = SnackBar(
                                      content: const Text('Merci de vierfier vos données'),
                                      backgroundColor: (Colors.red),
                                      action: SnackBarAction(
                                        label: 'fermer',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });
                              }
                            })),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                TextButton(
                  child: const Text(
                    'Créer un compte',
                    style: TextStyle(
                        fontSize: 15, fontFamily: "Helvetica", decoration: TextDecoration.underline, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ),
                    );
                  },
                )
              ])
            ]),
          )
        ],
      )),
    );
  }
}
