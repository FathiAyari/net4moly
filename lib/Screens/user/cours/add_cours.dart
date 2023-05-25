import 'package:flutter/material.dart';
import 'package:net4moly/Screens/configs/constants.dart';

class AddCours extends StatefulWidget {
  const AddCours({Key? key}) : super(key: key);

  @override
  State<AddCours> createState() => _AddCoursState();
}

class _AddCoursState extends State<AddCours> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        title: Text("Ajouter un cours"),
      ),
    );
  }
}
