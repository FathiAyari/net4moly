import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ServiceUser.dart';

void addformation(String content, int clientID, String label) async {
  final String baseUrl = 'http://localhost:8080/posts/addFormation';
  final token = ServiceUser.authenticateUser('balihamdi2000@gmail.com', '1234');
  final response = await http.post(
      Uri.parse(
          baseUrl + 'posts?content=$content&client_id=$clientID&label=$label'),
      headers: {
        'Authorization': 'Bearer $token',
      });

  if (response.statusCode == 201) {
    // Post created successfully
    print('Post created!');
  } else {
    // Error occurred
    print('Error: ${response.statusCode}');
  }
}



/*Future<void> addFormation(
  String content,
  int clientID,
  String label,
) async {
  try {
    final token =
        await ServiceUser.authenticateUser('balihamdi2000@gmail.com', '1234');
    print(token);
    final url = Uri.parse('http://192.168.1.14:8080/posts/addFormation');
    final queryParams = {
      'content': content,
      'client_id': 1,
      'label': label,
    };
    final response = await http.post(url,
        body: jsonEncode(queryParams),
        headers: {'Authorzation': 'Bearer $token'});
    if (response.statusCode == 200) {
      // Post added successfully
      // final newPost = jsonDecode(response.body);
      //currentUser.posts.add(newPost);
    } else {
      // Post failed, handle error
      throw Exception('Failed to add formation Error: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
  }
}*/
