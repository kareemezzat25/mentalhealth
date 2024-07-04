import 'package:flutter/material.dart';

class CommentsProvider extends ChangeNotifier {
  int _commentsCount = 0;
  List<Map<String, dynamic>> _comments = [];

  int get commentsCount => _commentsCount;
  List<Map<String, dynamic>> get comments => _comments;

  void setCommentsCount(int count) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentsCount = count;
      notifyListeners();
    });
  }

  void addComment(Map<String, dynamic> comment) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _comments.add(comment);
      notifyListeners();
    });
  }

  // Additional methods as needed for updating comments or managing state
}
