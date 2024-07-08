import 'dart:convert';

import 'package:http/http.dart' as http;

class DepTestApi {
  static Future<String> submitDepressionTest({
    required String? story,
    required int totalWeight,
    required String gender,
    required int age,
  }) async {
    final Uri apiUrl = Uri.parse('https://nexus-api-h3ik.onrender.com/api/users/test-depression');

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': story ?? '',
          'sum': totalWeight,
          'gender': gender,
          'age': age,
        }),
      );
      print('Text :${story}');
      // Print the response to debug console
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body; // Return the response body directly as a string
      } else {
        throw Exception('Failed to submit test: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to submit test: $e');
    }
  }
}
