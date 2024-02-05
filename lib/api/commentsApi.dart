// commentApi.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

class CommentApi {
  static const apiUrl = 'https://mentalmediator.somee.com/api/posts';

  static Future<void> updateComment(
    int postId,
    int commentId,
    String newContent,
  ) async {
    try {
      final Map<String, dynamic> requestData = {
        "content": newContent,
      };

      final String requestBody = jsonEncode(requestData);
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        final http.Response response = await http.put(
          Uri.parse('$apiUrl/$postId/comments/$commentId'),
          headers: headers,
          body: requestBody,
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update comment');
        }
      } else {
        print('Token not available');
        // Handle case where token is not available
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during updateComment: $error');
    }
  }

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

  static Future<void> deleteComment(int postId, int commentId) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
        };

        final http.Response response = await http.delete(
          Uri.parse('$apiUrl/$postId/comments/$commentId'),
          headers: headers,
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to delete comment');
        }
      } else {
        print('Token not available');
        // Handle case where token is not available
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during deleteComment: $error');
    }
  }
}
