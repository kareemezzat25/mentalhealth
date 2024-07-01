import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

class PostsApi {
  static const apiUrl = 'https://nexus-api-h3ik.onrender.com/api/posts';
  static List<Map<String, dynamic>> posts = []; // List to store posts
  static const pageSize = 30; // Set the page size to 30

  // New method to reload posts
  static Future<void> reloadPosts() async {}
  static Future<List<Map<String, dynamic>>> fetchPaginatedPosts(
    int pageNumber,
    int pageSize, {
    bool? confessionsOnly,
    String? title,
    String? content,
    String? username,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final Map<String, String> queryParams = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    if (confessionsOnly != null) {
      queryParams['ConfessionsOnly'] = confessionsOnly.toString();
    }
    if (title != null) {
      queryParams['Title'] = title;
    }
    if (content != null) {
      queryParams['Content'] = content;
    }
    if (username != null) {
      queryParams['Username'] = username;
    }
    if (startTime != null) {
      queryParams['StartTime'] = startTime.toIso8601String();
    }
    if (endTime != null) {
      queryParams['EndTime'] = endTime.toIso8601String();
    }

    final Uri uri = Uri.parse('$apiUrl').replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load paginated posts');
    }
  }

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

  static Future<Map<String, dynamic>> editPost(
      int postId, String newTitle, String newContent) async {
    try {
      final String? authToken = await Auth.getToken();

      if (authToken == null) {
        print('Error editing post. Authentication token is null.');
        return Map<String, dynamic>(); // Return an empty map
      }

      final Map<String, dynamic> requestData = {
        "title": newTitle,
        "content": newContent,
      };

      final String requestBody = jsonEncode(requestData);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final http.Response response = await http.put(
        Uri.parse('$apiUrl/$postId'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Return the updated post details if successful
        final Map<String, dynamic> updatedPost = json.decode(response.body);

        return updatedPost;
      } else {
        // Handle other status codes
        print('Failed to edit post. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return Map<String, dynamic>(); // Return an empty map
      }
    } catch (error) {
      print('Error during editPost: $error');
      return Map<String, dynamic>(); // Return an empty map
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUserPosts(
      String userId, int pageNumber, int pageSize) async {
    final String url =
        '$apiUrl/user/$userId?pageNumber=$pageNumber&pageSize=$pageSize';
    print('Fetching user posts from URL: $url');

    String? token = await Auth.getToken();
    if (token == null) {
      print('Authentication token is null');
      throw Exception('Authentication token is null');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      print('Error fetching user posts. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load user posts');
    }
  }

  // Inside postsApi.dart

  static Future<List<Map<String, dynamic>>> fetchPosts({
    int page = 1,
    int pageSize = 30,
  }) async {
    final response =
        await http.get(Uri.parse('$apiUrl?page=$page&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<String?> createPost(String title, String content, String token,
      bool isAnonymous, File? imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['isAnonymous'] = isAnonymous.toString();

      // Add image file if available
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photoPost',
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        );
      }

      var response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['url']; // Return the image URL
      } else {
        print('Failed to create post. Status code: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return null;
      }
    } catch (error) {
      print('Error during createPost: $error');
      return null;
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
