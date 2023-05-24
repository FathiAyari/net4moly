import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'ServiceUser.dart';

class StoryService {
  PickedFile? _pickedFile;
  AddStoryAPI(File imageFile, String description, int id) async {
    try {
      String id = "1";
      final token = await getToken();
      var request = MultipartRequest(
          'POST', Uri.parse('http://localhost:8080/storys/addStory'));

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(MultipartFile.fromBytes(
          'file', File(_pickedFile!.path).readAsBytesSync(),
          filename: _pickedFile!.path));
      request.fields['description'] = description;
      request.fields['id'] = id;

      var res = await request.send();
      if (res.statusCode == 200) {
        print("Uploaded!");
      } else if (res.statusCode == 403) {
        print("unauthorized");
      } else {
        print("Failed to upload 2");
      }
    } catch (e) {
      print(e);
    }
  }
}
