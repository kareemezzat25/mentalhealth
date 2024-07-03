import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/DepTestApi.dart';
import 'package:mentalhealthh/views/DoctorsPage.dart'; // Import your DoctorsPage widget
import 'package:mentalhealthh/views/Posts.dart'; // Import your Posts widget
import 'TestResultPage.dart'; // Import your TestResultPage widget

class DepressionTest extends StatefulWidget {
  @override
  _DepressionTestFormState createState() => _DepressionTestFormState();
}

class _DepressionTestFormState extends State<DepressionTest> {
  final _formKey = GlobalKey<FormState>();
  String? _story;
  String? _hopeless;
  String? _sleepProblems;
  String? _tired;
  String? _lossInterest;
  String? _concentration;
  String? _worthless;

  final List<String> options = ['Sometimes', 'Always', 'Never', 'Usually'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, String?> answers = {
        'hopeless': _hopeless,
        'sleepProblems': _sleepProblems,
        'tired': _tired,
        'lossInterest': _lossInterest,
        'concentration': _concentration,
        'worthless': _worthless,
      };

      try {
        final response = await DepTestApi.submitDepressionTest(
          story: _story,
          answers: answers,
        );

        String resultMessage;

        if (response) {
          resultMessage =
              'Depression Indicated\n\nHow Our Test Works:\n\nOur 3-Phase Analysis Process:\n\n- Response Weighting: We assign weights to your responses to determine if the overall sentiment tends to be more negative.\n- Sentiment Analysis: We use advanced techniques like VADER and RoBERTa, combined with user analysis, to assess if your responses indicate potential issues.\n- Depression Analysis: We compare your responses against a database of over 10,000 depression cases using machine learning models (decision trees, logistic regression, and support vector machines) to identify similarities.\n\nThis multi-phase approach allows us to provide a comprehensive assessment. However, it\'s important to note that this test is not a clinical diagnosis. Always consult with a mental health professional for a proper evaluation.';
        } else {
          resultMessage =
              'You are normal. Keep maintaining your mental health!';
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultPage(response),
          ),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit test: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Depression Test Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildDropdown(
                  'How often do you feel hopeless or helpless?',
                  (value) => _hopeless = value,
                  _hopeless,
                ),
                _buildDropdown(
                  'How often do you have trouble sleeping or experience changes in your sleep patterns (e.g., insomnia or oversleeping)?',
                  (value) => _sleepProblems = value,
                  _sleepProblems,
                ),
                _buildDropdown(
                  'How often do you feel excessively tired or lack energy?',
                  (value) => _tired = value,
                  _tired,
                ),
                _buildDropdown(
                  'How often do you lose interest or pleasure in activities you used to enjoy?',
                  (value) => _lossInterest = value,
                  _lossInterest,
                ),
                _buildDropdown(
                  'How often do you experience difficulty concentrating or making decisions?',
                  (value) => _concentration = value,
                  _concentration,
                ),
                _buildDropdown(
                  'How often do you feel worthless or excessively guilty?',
                  (value) => _worthless = value,
                  _worthless,
                ),
                _buildTextField('Tell us your story', (value) => _story = value),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
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

  Widget _buildDropdown(
      String labelText, Function(String?) onSaved, String? currentValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(fontSize: 18),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 18),
            ),
            hint: Text(
              'Select an option',
              style: TextStyle(fontSize: 16),
            ),
            value: currentValue,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option, style: TextStyle(fontSize: 16)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                onSaved(value);
              });
            },
            validator: (value) =>
                value == null ? 'Please select an option' : null,
            onSaved: (value) {
              onSaved(value);
            },
          ),
        ],
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
