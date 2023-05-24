import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class ServiceUser {
  static Future<String> authenticateUser(String email, String password) async {
    final response = await post(
      Uri.parse('http://localhost:8080/api/v1/auth/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      // Authentication successful, return authentication token
      final data = json.decode(response.body);
      print(data['token']);
      return data['token'];
    } else {
      // Authentication failed, handle error
      throw Exception('Failed to authenticate user.');
    }
  }

  /*Future<String> getToken() async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/auth/authenticate'),
      body: {
        'username': 'balihamdi2000@gmail.com',
        'password': '1234',
      },
    );
    final data = json.decode(response.body);
    return data['token'];
  }*/
}

Future<String> getToken() async {
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
