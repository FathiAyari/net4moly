import 'package:flutter/material.dart';
import 'package:net4moly/Screens/configs/constants.dart';

class EditPost extends StatefulWidget {
  final String postId;
  const EditPost({Key? key, required this.postId}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier publication"),
        backgroundColor: AppColors.mainColor1,
      ),
    );
  }
}
