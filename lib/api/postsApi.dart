import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

class PostsApi {
  static const apiUrl = 'https://mentalmediator.somee.com/api/posts';

  static Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Inside the createPost function
  static Future<void> createPost(
      String title, String content, String token) async {
    try {
      final Map<String, dynamic> requestData = {
        "title": title,
        "content": content,
      };

      final String requestBody = jsonEncode(requestData);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include token in headers
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create post');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during createPost: $error');
    }
  }
}
