import 'package:flutter/material.dart';

class NotificationCountProvider extends ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void updateUnreadCount(int count) {
    // Use Future.microtask to defer the notifyListeners() call
    Future.microtask(() {
      _unreadCount = count;
      notifyListeners();
    });
  }
}
