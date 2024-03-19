import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
  String apiUrl = 'https://nexus-api-h3ik.onrender.com/api/profiles/$userId';
  String? token = await Auth.getToken();

  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch user profile');
  }
}

Future<void> updateUserProfile(
  String userId,
  String firstName,
  String lastName,
  String gender,
  String birthDate,
) async {
  try {
    String apiUrl = 'https://nexus-api-h3ik.onrender.com/api/profiles/$userId';
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Token not available');
    }

    Map<String, dynamic> requestBody = {
      'FirstName': firstName,
      'LastName': lastName,
      'Gender': gender,
      'BirthDate': birthDate,
    };

    http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('User profile updated successfully');
    } else {
      print(
          'Failed to update user profile. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update user profile');
    }
  } catch (e) {
    print('Error updating user profile: $e');
    throw Exception('Error updating user profile: $e');
  }
}
