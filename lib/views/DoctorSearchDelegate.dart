import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart';
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/DoctorDetailPage.dart';

class DoctorSearchDelegate extends SearchDelegate {
  final List<Doctor> doctors;

  String? name;
  String? specialization;
  String? gender;
  String? city;
  double? minFees;
  double? maxFees;

  DoctorSearchDelegate(this.doctors);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          name = null;
          specialization = null;
          gender = null;
          city = null;
          minFees = null;
          maxFees = null;
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: DoctorsApi().fetchDoctors(
        name: name,
        specialization: specialization,
        gender: gender,
        city: city,
        minFees: minFees,
        maxFees: maxFees,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No doctors found'));
        } else {
          List<Doctor> searchResults = snapshot.data!;
          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              Doctor doctor = searchResults[index];
              String imageUrl = doctor.photoUrl.isNotEmpty
                  ? doctor.photoUrl
                  : 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailPage(doctor: doctor),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 99, 185, 225),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 40,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.fullName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${doctor.specialization}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Gender: ${doctor.gender}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'City: ${doctor.city}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Session Fees: ${doctor.sessionFees} hrs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: [
          buildSearchField(
            label: 'Name',
            onChanged: (value) => name = value,
          ),
          buildSearchField(
            label: 'Specialization',
            onChanged: (value) => specialization = value,
          ),
          buildSearchField(
            label: 'Gender',
            onChanged: (value) => gender = value,
          ),
          buildSearchField(
            label: 'City',
            onChanged: (value) => city = value,
          ),
          buildSearchField(
            label: 'Min Fees',
            keyboardType: TextInputType.number,
            onChanged: (value) => minFees = double.tryParse(value),
          ),
          buildSearchField(
            label: 'Max Fees',
            keyboardType: TextInputType.number,
            onChanged: (value) => maxFees = double.tryParse(value),
          ),
          ElevatedButton(
            onPressed: () {
              showResults(context);
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget buildSearchField({
    required String label,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}
