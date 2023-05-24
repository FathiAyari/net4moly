import 'ServiceUser.dart';
import 'package:http/http.dart';

void setReaction(int idPost, int clientID) async {
  final String baseUrl = 'http://localhost:8080/reaction/add';
  final token = ServiceUser.authenticateUser('mbi@gmail.com', '123');
  final response = await post(
      Uri.parse(baseUrl + 'posts?idPost=$idPost&idClient=$clientID'),
      headers: {
        'Authorization': 'Bearer $token',
      });

  if (response.statusCode == 201) {
    // Post created successfully
    print('reaction added!');
  } else {
    // Error occurred
    print('Error: ${response.statusCode}');
  }
}
