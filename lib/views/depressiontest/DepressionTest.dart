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
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _storyController = TextEditingController(); // Add this line
  Map<int, int?> _answers = {};
  String? _story;
  String? _gender;
  int? _age;
  bool _showGenderError = false;

  @override
  void dispose() {
    _ageController.dispose();
    _storyController.dispose(); // Add this line
    super.dispose();
  }

  void _submitForm() async {
    setState(() {
      _showGenderError = _gender == null;
    });

    if (_formKey.currentState!.validate() && _gender != null) {
      _formKey.currentState!.save();

      // Calculate total sum of weights
      int totalWeight = _calculateTotalWeight();

      try {
        final String response = await DepTestApi.submitDepressionTest(
          story: _story,
          totalWeight: totalWeight,
          gender: _gender!,
          age: _age!,
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
                _buildGenderField(),
                if (_showGenderError)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Please choose your gender',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                _buildAgeField(),
                for (var question in questions) _buildRadioQuestion(question),
                _buildTextField('Tell us your story', _storyController), // Modify this line
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

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: Text('Male'),
          leading: Radio<String>(
            value: 'male',
            groupValue: _gender,
            onChanged: (String? value) {
              setState(() {
                _gender = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Female'),
          leading: Radio<String>(
            value: 'female',
            groupValue: _gender,
            onChanged: (String? value) {
              setState(() {
                _gender = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Age',
          labelStyle: TextStyle(fontSize: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your age';
          }
          final age = int.tryParse(value);
          if (age == null || age <= 0) {
            return 'Please enter a valid age';
          }
          return null;
        },
        onSaved: (value) {
          _age = int.parse(value!);
        },
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

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 18),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter a story' : null,
        onSaved: (value) {
          _story = value;
        },
      ),
    );
  }
}
