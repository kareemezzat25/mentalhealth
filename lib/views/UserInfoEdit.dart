import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/api/UserProfileApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';

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
      if (_image != null) {
      await Auth.setPhotoUrl(widget.photoUrl);
    }
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
        elevation: 0,
        backgroundColor: Colors.transparent,
         // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : NetworkImage(widget.photoUrl) as ImageProvider<Object>?,
              ),
            ),
            SizedBox(height: 10), // Add some space
            ElevatedButton(
                onPressed: _getImage,
                child: Text('Select Photo'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(50, 40)), // Set minimum width and height
                  backgroundColor: MaterialStateProperty.all(Color(0xff01579B)), // Custom button color
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Custom text color
                ),
              ),

            SizedBox(height: 20), // Add some space
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(borderRadius:BorderRadius.circular(15)), // Add border to text field
              ),
            ),
            SizedBox(height: 10), // Add some space
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(borderRadius:BorderRadius.circular(15)), // Add border to text field
              ),
            ),
            SizedBox(height: 10), // Add some space
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(borderRadius:BorderRadius.circular(15)), // Add border to text field
              ),
            ),
            SizedBox(height: 10), // Add some space
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Birthdate',
                border: OutlineInputBorder(borderRadius:BorderRadius.circular(15)), // Add border to text field
              ),
            ),
            SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: _updateProfile,
              child: SizedBox(
                width: 100, // Set width to match parent
                child: Center(
                  child: Text('Update'),
                ),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(200, 50)), // Set minimum width and height
                backgroundColor: MaterialStateProperty.all(Color(0xff01579B)), // Custom button color
                foregroundColor: MaterialStateProperty.all(Colors.white), // Custom text color
              ),
            ),

          ],
        ),
      ),
    );
  }
}
