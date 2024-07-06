import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/DepTestApi.dart';
import 'package:mentalhealthh/views/depressiontest/TestResultview.dart';
import 'package:mentalhealthh/views/depressiontest/questionslistview.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';
import 'package:mentalhealthh/models/Questions.dart'; // Import your Question model

class DepressionTest extends StatefulWidget {
  final String userId;

  DepressionTest({required this.userId});

  @override
  _DepressionTestFormState createState() => _DepressionTestFormState();
}

class _DepressionTestFormState extends State<DepressionTest> {
  final _formKey = GlobalKey<FormState>();
  Map<int, int?> _answers = {};
  String? _story;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Calculate total sum of weights
      int totalWeight = _calculateTotalWeight();

      try {
        final String response = await DepTestApi.submitDepressionTest(
          story: _story,
          totalWeight: totalWeight,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultPage(response, userid: widget.userId),
          ),
        );
      } catch (e) {
        print('Failed to submit test: $e');
      }
    }
  }

  int _calculateTotalWeight() {
    int totalWeight = 0;
    _answers.forEach((key, value) {
      if (value != null) {
        totalWeight += value!;
      }
    });
    return totalWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Depression Test Form'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: widget.userId != "" ? CommonDrawer(userId: widget.userId) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Iterate over questions list and build _buildRadioQuestion dynamically
                for (var question in questions) _buildRadioQuestion(question),
                _buildTextField('Tell us your story', (value) => _story = value),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff3699A2),
                    onPrimary: Colors.white,
                  ),
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioQuestion(Question question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormField<int>(
        validator: (value) {
          if (_answers[question.questionNumber] == null) {
            return 'Please enter an answer';
          }
          return null;
        },
        builder: (FormFieldState<int> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${question.questionNumber}:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(question.option1),
                leading: Radio<int>(
                  value: 0,
                  groupValue: _answers[question.questionNumber],
                  onChanged: (int? value) {
                    setState(() {
                      _answers[question.questionNumber] = value;
                    });
                    state.didChange(value);
                  },
                ),
              ),
              ListTile(
                title: Text(question.option2),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _answers[question.questionNumber],
                  onChanged: (int? value) {
                    setState(() {
                      _answers[question.questionNumber] = value;
                    });
                    state.didChange(value);
                  },
                ),
              ),
              ListTile(
                title: Text(question.option3),
                leading: Radio<int>(
                  value: 2,
                  groupValue: _answers[question.questionNumber],
                  onChanged: (int? value) {
                    setState(() {
                      _answers[question.questionNumber] = value;
                    });
                    state.didChange(value);
                  },
                ),
              ),
              ListTile(
                title: Text(question.option4),
                leading: Radio<int>(
                  value: 3,
                  groupValue: _answers[question.questionNumber],
                  onChanged: (int? value) {
                    setState(() {
                      _answers[question.questionNumber] = value;
                    });
                    state.didChange(value);
                  },
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(String labelText, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: 4,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 18),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter a story' : null,
        onSaved: onSaved,
      ),
    );
  }
}
