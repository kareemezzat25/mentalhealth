// radio_question_widget.dart
import 'package:flutter/material.dart';

class RadioQuestionWidget extends StatelessWidget {
  final int questionNumber;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final Map<int, int?> answers;
  final Function(int, int?) onChanged;

  RadioQuestionWidget({
    required this.questionNumber,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question $questionNumber:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text(option1),
            leading: Radio<int>(
              value: 0,
              groupValue: answers[questionNumber],
              onChanged: (int? value) {
                onChanged(questionNumber, value);
              },
            ),
          ),
          ListTile(
            title: Text(option2),
            leading: Radio<int>(
              value: 1,
              groupValue: answers[questionNumber],
              onChanged: (int? value) {
                onChanged(questionNumber, value);
              },
            ),
          ),
          ListTile(
            title: Text(option3),
            leading: Radio<int>(
              value: 2,
              groupValue: answers[questionNumber],
              onChanged: (int? value) {
                onChanged(questionNumber, value);
              },
            ),
          ),
          ListTile(
            title: Text(option4),
            leading: Radio<int>(
              value: 3,
              groupValue: answers[questionNumber],
              onChanged: (int? value) {
                onChanged(questionNumber, value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
