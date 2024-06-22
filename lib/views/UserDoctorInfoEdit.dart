import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/services/UserProfileApi.dart';

class UserDoctorInfoEdit extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;
  final String photoUrl;
  final String? specialization;
  final String? biography;
  final String? city;
  final String? location;
  final double ?sessionFees;

  UserDoctorInfoEdit({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.photoUrl,
    this.specialization,
    this.biography,
    this.city,
    this.location,
    this.sessionFees,
  });

  @override
  _UserDoctorInfoEditState createState() => _UserDoctorInfoEditState();
}

class _UserDoctorInfoEditState extends State<UserDoctorInfoEdit> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  TextEditingController _biographyController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _sessionFeesController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
    _genderController.text = widget.gender;
    _birthDateController.text = widget.birthDate;
    _specializationController.text = widget.specialization ?? '';
    _biographyController.text = widget.biography ?? '';
    _cityController.text = widget.city ?? '';
    _locationController.text = widget.location ?? '';
    _sessionFeesController.text = widget.sessionFees.toString();
  }

  void _updateProfile(BuildContext context) async {
    try {
      await updateDoctorProfile(
        widget.userId,
        _firstNameController.text,
        _lastNameController.text,
        _genderController.text,
        _birthDateController.text,
        _image,
        _specializationController.text,
        _biographyController.text,
        _cityController.text,
        _locationController.text,
        double.parse(_sessionFeesController.text),
      );

      Navigator.pop(context, 'refresh');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 122,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : NetworkImage(widget.photoUrl) as ImageProvider<Object>?,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Select Photo'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Birthdate',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            if (widget.specialization != null) ...[
              SizedBox(height: 10),
              TextFormField(
                controller: _specializationController,
                decoration: InputDecoration(
                  labelText: 'Specialization',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _biographyController,
                decoration: InputDecoration(
                  labelText: 'Biography',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _sessionFeesController,
              decoration: InputDecoration(
                labelText: 'Session Fees',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            ],
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateProfile(context),
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
