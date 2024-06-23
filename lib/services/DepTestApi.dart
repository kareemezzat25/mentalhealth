// api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class DepTestApi {
  static Future<bool> submitDepressionTest({
    required String? story,
    required Map<String, String?> answers,
  }) async {
    int sometimes = 0;
    int always = 0;
    int never = 0;
    int usually = 0;

    answers.forEach((key, value) {
      switch (value) {
        case 'Sometimes':
          sometimes++;
          break;
        case 'Always':
          always++;
          break;
        case 'Never':
          never++;
          break;
        case 'Usually':
          usually++;
          break;
      }
    });

    final response = await http.post(
      Uri.parse(
          'https://nexus-api-h3ik.onrender.com/api/users/test-depression'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': story,
        'sometimes': sometimes,
        'always': always,
        'never': never,
        'usually': usually,
      }),
    );

    if (response.statusCode == 200) {
      // Directly parse the response as a boolean
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception('Failed to submit test');
    }
  }
}
