// commentApi.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

class CommentApi {
  static const apiUrl = 'https://nexus-api-h3ik.onrender.com/api/posts';

  static Future<Map<String, dynamic>> fetchCommentDetails(
    int postId,
    int commentId,
  ) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
        };

        final http.Response response = await http.get(
          Uri.parse('$apiUrl/$postId/comments/$commentId'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Failed to fetch comment details');
        }
      } else {
        print('Token not available');
        throw Exception('Token not available');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during fetchCommentDetails: $error');
      throw error;
    }
  }

  static Future<Map<String, dynamic>> updateComment(
      int postId, int commentId, String newContent) async {
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

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          if (errorResponse['title'] == 'Forbidden') {
            return errorResponse;
          }
          throw Exception('Failed to update comment');
        }
      } else {
        throw Exception('Token not available');
      }
    } catch (error) {
      print('Error during updateComment: $error');
      throw error;
    }
  }

  static Future<Map<String, dynamic>> createComment(
      int postId, String content) async {
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

        if (response.statusCode == 201) {
          return json.decode(response.body);
        } else {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          if (errorResponse['title'] == 'Forbidden') {
            return errorResponse;
          }
          throw Exception('Failed to create comment');
        }
      } else {
        throw Exception('Token not available');
      }
    } catch (error) {
      print('Error during createComment: $error');
      throw error;
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

  static Future<Map<String, dynamic>> updateReply(
      int postId, int commentId, int replyId, String newContent) async {
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
          Uri.parse('$apiUrl/$postId/comments/$commentId/replies/$replyId'),
          headers: headers,
          body: requestBody,
        );

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          if (errorResponse['title'] == 'Forbidden') {
            return errorResponse;
          }
          throw Exception('Failed to update reply');
        }
      } else {
        throw Exception('Token not available');
      }
    } catch (error) {
      print('Error during updateReply: $error');
      throw error;
    }
  }

  static Future<void> deleteReply(
      int postId, int commentId, int replyId) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
        };

        final http.Response response = await http.delete(
          Uri.parse('$apiUrl/$postId/comments/$commentId/replies/$replyId'),
          headers: headers,
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to delete reply');
        }
      } else {
        print('Token not available');
        // Handle case where token is not available
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during deleteReply: $error');
    }
  }

  static Future<Map<String, dynamic>> fetchReplyDetails(
    int postId,
    int commentId,
    int replyId,
  ) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
        };

        final http.Response response = await http.get(
          Uri.parse('$apiUrl/$postId/comments/$commentId/replies/$replyId'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data;
        } else {
          throw Exception('Failed to fetch reply details');
        }
      } else {
        print('Token not available');
        throw Exception('Token not available');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during fetchReplyDetails: $error');
      throw error;
    }
  }

  static Future<Map<String, dynamic>> postCommentReply(
      int postId, int commentId, String content) async {
    try {
      String? token = await Auth.getToken();

      if (token == null) {
        throw Exception('Token not available');
      }

      final Map<String, dynamic> requestData = {
        "content": content,
      };

      final String requestBody = jsonEncode(requestData);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final http.Response response = await http.post(
        Uri.parse('$apiUrl/$postId/comments/$commentId/replies'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        if (errorResponse['title'] == 'Forbidden') {
          return errorResponse;
        }
        throw Exception('Failed to post comment reply');
      }
    } catch (error) {
      print('Error during postCommentReply: $error');
      throw error;
    }
  }
}
