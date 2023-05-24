import 'package:flutter/material.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Services/AuthServices.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool emailValid() {
    bool emailValidFormat =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
    if (emailController.text == "" || emailValidFormat == false) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
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
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 100,
                    width: 100,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30)),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 150,
                    width: 250,
                    child: Image.asset(
                      "assets/images/logo_white.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                    child: Text(
                      "Entrez votre email et nous vous enverrons un lien pour réinitialiser votre mot de passe.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Helvetica",
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8)),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 20, 0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Email',
                      style: TextStyle(fontSize: 17, fontFamily: "TodaySBL", color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
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
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            )),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
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
                                    AuthServices().resetPassword(emailController.text).then((value) async {
                                      if (value) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        final snackBar = SnackBar(
                                          content: const Text('Un lien de recuperation à ete envoyé à votre mail'),
                                          backgroundColor: (Colors.green),
                                          action: SnackBarAction(
                                            label: 'fermer',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        final snackBar = SnackBar(
                                          content: const Text('Merci de vierfier votre email'),
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
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
