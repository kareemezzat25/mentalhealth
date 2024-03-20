import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/api/UserProfileApi.dart';

class UserInfoEdit extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;
  final String photoUrl;

  UserInfoEdit({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.photoUrl,
  });

  @override
  _UserInfoEditState createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
    _genderController.text = widget.gender;
    _birthDateController.text = widget.birthDate;
  }

  void _updateProfile() async {
    try {
      await updateUserProfile(
        widget.userId,
        _firstNameController.text,
        _lastNameController.text,
        _genderController.text,
        _birthDateController.text,
        _image,
      );
      Navigator.pop(context, 'refresh');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user profile')),
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
        title: Text('Edit User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 122,
                backgroundColor:
                    Colors.grey[300], // Add a background color for the avatar
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : NetworkImage(widget.photoUrl) as ImageProvider<Object>?,
              ),
            ),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Select Photo'),
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: 'Birthdate'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
