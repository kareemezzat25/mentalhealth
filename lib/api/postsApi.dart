import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/Posts.dart';

class PostsApi {
  static const apiUrl = 'https://mentalmediator.somee.com/api/posts';
  static List<Map<String, dynamic>> posts = []; // List to store posts

  // New method to reload posts
  static Future<void> reloadPosts() async {}

  // Inside deletePost function
  static Future<void> deletePost({
    required BuildContext context,
    required int postId,
    required Function onPostDeleted,
  }) async {
    try {
      final String? authToken = await Auth.getToken();

      if (authToken == null) {
        print('Error deleting post. Authentication token is null.');
        return;
      }

      final response = await http.delete(
        Uri.parse('$apiUrl/$postId'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Post deleted successfully
        print('Post deleted successfully');

        // Notify the callback function that a post is deleted
        onPostDeleted();

        // Navigate back to the previous screen
        Navigator.pop(context, 'refresh');
      } else {
        // Handle other status codes
        print('Error deleting post. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle network errors
      print('Error deleting post: $error');
    }
  }

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

  static Future<Map<String, dynamic>> fetchPostDetailsWithAuthor(
      int postId) async {
    final response = await http.get(Uri.parse('$apiUrl/$postId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load post details');
    }
  }

  // New method to fetch details of a specific post
  static Future<Map<String, dynamic>> fetchPostDetails(int postId) async {
    final response = await http.get(Uri.parse('$apiUrl/$postId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load post details');
    }
  }

  // New method to fetch comments for a specific post
  static Future<List<Map<String, dynamic>>> fetchPostComments(
      int postId) async {
    final response = await http.get(Uri.parse('$apiUrl/$postId/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load post comments');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchCommentReplies(
      int postId, int commentId) async {
    final response = await http
        .get(Uri.parse('$apiUrl/$postId/comments/$commentId/replies'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load comment replies');
    }
  }

  static Future<void> postCommentReply(
      int postId, int commentId, String content) async {
    try {
      // Get token
      String? token = await Auth.getToken();

      if (token == null) {
        print('Token not available');
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

      if (response.statusCode != 201) {
        print(
            'Failed to post comment reply. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to post comment reply');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during postCommentReply: $error');
      throw error;
    }
  }

  // static Future<void> deletePost(String postId) async {
  //   try {
  //     String? token = await Auth.getToken();

  //     if (token == null) {
  //       print('Token not available');
  //       throw Exception('Token not available');
  //     }

  //     final Map<String, String> headers = {
  //       'Authorization': 'Bearer $token',
  //     };

  //     final http.Response response = await http.delete(
  //       Uri.parse('$apiUrl/$postId'),
  //       headers: headers,
  //     );

  //     if (response.statusCode != 200) {
  //       print('Failed to delete post. Status Code: ${response.statusCode}');
  //       print('Response Body: ${response.body}');
  //       throw Exception('Failed to delete post');
  //     }
  //   } catch (error) {
  //     print('Error during post deletion: $error');
  //     throw error;
  //   }
  // }
}
