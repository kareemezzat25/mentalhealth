// dialog_helpers.dart
import 'package:flutter/material.dart';

Future<void> showForbiddenDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Offensive Content'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is an offensive content and violates our policy.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
