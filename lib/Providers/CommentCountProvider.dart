import 'package:flutter/foundation.dart';

class CommentCountProvider extends ChangeNotifier {
  int _commentCount = 0;

  int get commentCount => _commentCount;

  void updateCommentCount(int newCount) {
    _commentCount = newCount;
    notifyListeners();
  }
}
