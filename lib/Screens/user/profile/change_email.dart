import 'package:flutter/material.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/Services/AuthServices.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';
import 'package:net4moly/widget/input_field.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangeEmail> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Changer  votre email',
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InputField(label: 'Email', textInputType: TextInputType.emailAddress, controller: emailController),
            ),
            InputField(
              label: "Mot de passe",
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              prefixWidget: Icon(
                Icons.lock,
                color: AppColors.mainColor1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07),
              child: Container(
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
                            'Modifier',
                            style: TextStyle(fontSize: 20, fontFamily: "TodaySB", color: Colors.white),
                          ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              AuthServices().changeEmail(emailController.text, passwordController.text).then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (value == "done") {
                                  final snackBar = SnackBar(
                                    content: const Text('Vous avez changé votre email'),
                                    backgroundColor: (Colors.green),
                                    action: SnackBarAction(
                                      label: 'fermer',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text('${value}'),
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
                          }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
