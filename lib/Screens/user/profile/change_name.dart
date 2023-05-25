import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:net4moly/Screens/configs/constants.dart';
import 'package:net4moly/shared/dimensions/dimensions.dart';
import 'package:net4moly/widget/input_field.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangeName> {
  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Changer votre nom',
          style: TextStyle(),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InputField(label: 'Nom', textInputType: TextInputType.text, controller: nameController),
            ),
            InputField(label: 'Prénom', textInputType: TextInputType.text, controller: lastNameController),
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
                              var user = GetStorage().read('user');

                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user['id'])
                                    .update({'name': nameController.text, 'last_name': lastNameController.text});
                                user['name'] = nameController.text;
                                user['last_name'] = lastNameController.text;
                                await GetStorage().write('user', user);
                                setState(() {
                                  _isLoading = false;
                                });
                                final snackBar = SnackBar(
                                  content: const Text('Vous avez changé votre nom et prénom'),
                                  backgroundColor: (Colors.green),
                                  action: SnackBarAction(
                                    label: 'fermer',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
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
