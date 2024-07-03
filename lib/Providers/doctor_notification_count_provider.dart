import 'package:flutter/material.dart';

class DoctorNotificationCountProvider extends ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void updateUnreadCount(int count) {
    Future.microtask(() {
      _unreadCount = count;
      notifyListeners();
    });
  }
}
