// DepressionTest.dart

import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/DepTestApi.dart';

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
              'You are depressed. Please seek help from a mental health professional.';
        } else {
          resultMessage =
              'You are normal. Keep maintaining your mental health!';
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Test Result'),
              content: Text(resultMessage),
              actions: [
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
              children: <Widget>[
                _buildDropdown('How often do you feel hopeless or helpless?',
                    (value) => _hopeless = value),
                _buildDropdown(
                    'How often do you have trouble sleeping or experience changes in your sleep patterns (e.g., insomnia or oversleeping)?',
                    (value) => _sleepProblems = value),
                _buildDropdown(
                    'How often do you feel excessively tired or lack energy?',
                    (value) => _tired = value),
                _buildDropdown(
                    'How often do you lose interest or pleasure in activities you used to enjoy?',
                    (value) => _lossInterest = value),
                _buildDropdown(
                    'How often do you experience difficulty concentrating or making decisions?',
                    (value) => _concentration = value),
                _buildDropdown(
                    'How often do you feel worthless or excessively guilty?',
                    (value) => _worthless = value),
                _buildTextField(
                    'Tell us your story', (value) => _story = value),
                SizedBox(height: 20),
                ElevatedButton(
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

  Widget _buildDropdown(String labelText, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {},
        validator: (value) => value == null ? 'Please select an option' : null,
        onSaved: onSaved,
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
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter a story' : null,
        onSaved: onSaved,
      ),
    );
  }
}
