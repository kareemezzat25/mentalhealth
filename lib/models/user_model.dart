import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String userName = '';
  String userEmail = '';
  String photoUrl = ''; // Add photoUrl field

  void setUserInfo(String? name, String? email, String? url) {
    userName = name ?? '';
    userEmail = email ?? '';
    photoUrl = url ?? ''; // Set photoUrl
    notifyListeners();
  }
}
