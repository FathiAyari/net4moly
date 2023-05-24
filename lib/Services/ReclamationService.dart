import 'dart:convert';
import 'package:http/http.dart';

import 'ServiceUser.dart';

Future<void> reclamer(
  int clientID,
  String description,
) async {
  try {
    final Token = await ServiceUser.authenticateUser('mbi@gmail.com', '123');
    print(Token);
    final url = Uri.parse('http://localhost:8080/reclameation/add/');
    final queryParams = {
      'client_id': 1,
      'description': description,
    };
    final response = await post(url, body: jsonEncode(queryParams), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorzation':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiYWxpaGFtZGkyMDAwQGdtYWlsLmNvbSIsImlhdCI6MTY3OTg2NDExMywiZXhwIjoxNjc5ODY1NTUzfQ.CSRRoWfvry0rtLwBuPeAVTCMJJ7gD9ag-neV_eGSU44'
    });
    if (response.statusCode == 200) {
      // Post added successfully
      // final newPost = jsonDecode(response.body);
      //currentUser.posts.add(newPost);
    } else {
      // Post failed, handle error
      throw Exception('Failed to add post. Error: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
  }
}
