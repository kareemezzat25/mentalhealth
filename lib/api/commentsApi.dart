// commentApi.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

class CommentApi {
  static const apiUrl = 'https://mentalmediator.somee.com/api/posts';

  static Future<void> createComment(int postId, String content) async {
    try {
      final Map<String, dynamic> requestData = {
        "content": content,
      };

      final String requestBody = jsonEncode(requestData);
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        final http.Response response = await http.post(
          Uri.parse('$apiUrl/$postId/comments'),
          headers: headers,
          body: requestBody,
        );

        if (response.statusCode != 201) {
          throw Exception('Failed to create comment');
        }
      } else {
        print('Token not available');
        // Handle case where token is not available
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during createComment: $error');
    }
  }
}
