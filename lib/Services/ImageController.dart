import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'ServiceUser.dart';

class ImageController extends GetxController {
  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;
  final picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    _pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      update();
    }
  }

  Future<void> pickImage2(BuildContext context) async {
    _pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      update();
    }
  }

  /*Upload() async {
    var data = {
      "imageFile": "$_pickedFile",
      "id": 1,
    };
    if (_pickedFile != null ) {
      String email = "balihamdi2000@gmail.com";
      String password = "1234";
      String token = await ServiceUser.authenticateUser(email, password);
      http.Response response = await http.post(
          Uri.parse('http://192.168.80.1:8080/api/image/upload'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: json.encode(data));
    } else {
      print("failed to upload");
    }
  }*/

  /*Upload() async {
    var postUri = Uri.parse("http://localhost:8080/api/image/upload");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['id'] = '1';
    request.files.add(new http.MultipartFile.fromBytes('imageFile', await File.fromUri(Path).readAsBytes(), contentType: new MediaType('image', 'jpeg')));

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }*/

  /*Upload() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://192.168.137.118:8080/api/image/upload"));

    request.fields['id'] = "1";

    request.files
        .add(await http.MultipartFile.fromPath('imageFile', _pickedFile!.path));
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
  }*/

  UploadImage(String token, String id, File imageFile) async {
    String id = "1";
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.83:8080/api/image/upload'));

    request.headers['Authorization'] = 'Bearer ${token}';
    request.fields['id'] = id.toString();
    request.files.add(http.MultipartFile.fromBytes(
        'imageFile', File(_pickedFile!.path).readAsBytesSync(),
        filename: _pickedFile!.path));
    var res = await request.send();
    if (res.statusCode == 200) {
      print("Uploaded!");
    } else if (res.statusCode == 403) {
      print("unauthorized");
    } else {
      print("Failed to upload 2");
    }
  }
  /*Future<void> uploadImage(String token, File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.80.1:8080/api/image/upload'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id'] = '1';
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    final response = await http.Client().send(request);
    final responseJson = json.decode(await response.stream.bytesToString());
    print(responseJson);
  }*/

  /*Future<String> uploadImage(String token, String id, File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.83:8080/api/image/upload'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id'] = '1';
    request.files
        .add(await http.MultipartFile.fromPath('imageFile', imageFile.path));
    final response = await http.Client().send(request);
    final responseJson = json.decode(await response.stream.bytesToString());
    print(responseJson);
    return responseJson['imageUrl'];
  }*/
}
