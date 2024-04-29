import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';

Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
  String apiUrl = 'https://nexus-api-h3ik.onrender.com/api/users/$userId';
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
  File? photo,
) async {
  try {
    String apiUrl = 'https://nexus-api-h3ik.onrender.com/api/profiles/$userId';
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Token not available');
    }

    var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';

    // Add form fields
    request.fields['FirstName'] = firstName;
    request.fields['LastName'] = lastName;
    request.fields['Gender'] = gender;
    request.fields['BirthDate'] = birthDate;

    // Add photo file if available
    if (photo != null) {
      request.files.add(
        http.MultipartFile(
          'Photo',
          photo.readAsBytes().asStream(),
          photo.lengthSync(),
          filename: photo.path.split('/').last,
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      var responseBody = await response.stream.bytesToString();
      var userData = jsonDecode(responseBody);
      print('User profile updated successfully: $userData');
    } else {
      print(
          'Failed to update user profile. Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
      throw Exception('Failed to update user profile');
    }
  } catch (e) {
    print('Error updating user profile: $e');
    throw Exception('Error updating user profile: $e');
  }
}
