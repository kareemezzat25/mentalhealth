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
  final TextEditingController _storyController = TextEditingController();
  final TextEditingController _fatherPunishmentController = TextEditingController();
  final TextEditingController _houseAtmosphereController = TextEditingController();
  final TextEditingController _importantPeopleController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _importantEventsController = TextEditingController();
  final TextEditingController _solutionsController = TextEditingController();
  final TextEditingController _suicidalThoughtsController = TextEditingController();
  
  Map<int, int?> _answers = {};
  String? _story;
  String? _fatherPunishment;
  String? _houseAtmosphere;
  String? _importantPeople;
  String? _problem;
  String? _importantEvents;
  String? _solutions;
  String? _suicidalThoughts;
  String? _gender;
  int? _age;
  bool _showGenderError = false;

  @override
  void dispose() {
    _ageController.dispose();
    _storyController.dispose();
    _fatherPunishmentController.dispose();
    _houseAtmosphereController.dispose();
    _importantPeopleController.dispose();
    _problemController.dispose();
    _importantEventsController.dispose();
    _solutionsController.dispose();
    _suicidalThoughtsController.dispose();
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

      // Concatenate the relevant text fields into a single story string
      String fullStory = [
        _story,
        _houseAtmosphere,
        _problem,
        _importantEvents,
        _solutions,
        _suicidalThoughts
      ].where((text) => text != null && text!.isNotEmpty).join(' ');

      try {
        final String response = await DepTestApi.submitDepressionTest(
          story: fullStory,
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
                _buildTextField( _storyController,'Tell us your story'),
                _buildTextField( _fatherPunishmentController,'How did your father and mother punish you?'),
                _buildTextField( _houseAtmosphereController,'What is your impression of the atmosphere of the house?'),
                _buildTextField( _importantPeopleController,'Who are the most important people in your life?'),
                _buildTextField(_problemController,'Tell us your problem'),
                _buildTextField(_importantEventsController,'Mention the most important events that you believe are related to this problem'),
                _buildTextField( _solutionsController,'What solutions do you think will help solve your problem?'),
                _buildTextField(_suicidalThoughtsController,'Tell us about your experience with suicidal thoughts or attempts if you have any (if you don\'t have any, leave it blank)',
),
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

  Widget _buildTextField(TextEditingController controller, String questionText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        questionText,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter $questionText' : null,
            onSaved: (value) {
              if (controller == _storyController) {
                _story = value;
              } else if (controller == _fatherPunishmentController) {
                _fatherPunishment = value;
              } else if (controller == _houseAtmosphereController) {
                _houseAtmosphere = value;
              } else if (controller == _importantPeopleController) {
                _importantPeople = value;
              } else if (controller == _problemController) {
                _problem = value;
              } else if (controller == _importantEventsController) {
                _importantEvents = value;
              } else if (controller == _solutionsController) {
                _solutions = value;
              } else if (controller == _suicidalThoughtsController) {
                _suicidalThoughts = value;
              }
            },
          ),
        ),
      ),
    ],
  );
}
}