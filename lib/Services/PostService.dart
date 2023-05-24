import 'dart:convert';
import 'package:http/http.dart';

import 'ServiceUser.dart';

Future<void> addPost(
  String content,
  int clientID,
  String label,
  String type,
) async {
  try {
    final Token = await ServiceUser.authenticateUser('mbi@gmail.com', '123');
    print(Token);
    final url = Uri.parse('http://localhost:8080/posts/addPost');
    final queryParams = {
      'content': content,
      'client_id': 1,
      'label': label,
      'type': type,
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

Future<String> getPostId() async {
  final response = await post(
    Uri.parse('http://localhost:8080/api/v1/auth/authenticate'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: <String, String>{
      'username': 'balihamdi2000@gmail.com',
      'password': '1234',
    },
  );

  if (response.statusCode == 200) {
    final token = response.body;
    print(token);
    return token;
  } else {
    throw Exception('Failed to get token');
  }
}
