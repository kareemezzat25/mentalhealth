import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart';
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/DoctorDetailPage.dart';

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  bool isLoading = false;
  String selectedGender = 'All';
  String selectedName = '';
  double minSessionFees = 0;
  double maxSessionFees = 1000;
  String selectedSpecialization = 'All';
  String selectedCity = '';

  List<String> specializations = [
    'All',
    'ClinicalPsychology',
    'CounselingPsychology',
    'HealthPsychology',
    'NeuroPsychology',
    'ForensicPsychology',
    'SchoolPsychology',
    'SocialPsychology',
  ];

  @override
  void initState() {
    super.initState();
    fetchDoctorsData();
  }

  Future<void> fetchDoctorsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Doctor> fetchedDoctors = await DoctorsApi().fetchDoctors();

      setState(() {
        doctors = fetchedDoctors;
        filteredDoctors = fetchedDoctors;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching doctors: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterDoctors() {
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        bool matchesGender = selectedGender == 'All' || doctor.gender == selectedGender;
        bool matchesName = selectedName.isEmpty || doctor.fullName.toLowerCase().contains(selectedName.toLowerCase());
        bool matchesFees = doctor.sessionFees >= minSessionFees && doctor.sessionFees <= maxSessionFees;
        bool matchesSpecialization = selectedSpecialization == 'All' || doctor.specialization == selectedSpecialization;
        bool matchesCity = selectedCity.isEmpty || doctor.city.toLowerCase().contains(selectedCity.toLowerCase());
        return matchesGender && matchesName && matchesFees && matchesSpecialization && matchesCity;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Name'),
                              onChanged: (value) {
                                setState(() {
                                  selectedName = value;
                                });
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: 'City'),
                              onChanged: (value) {
                                setState(() {
                                  selectedCity = value;
                                });
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: selectedSpecialization,
                                    items: specializations.map((String specialization) {
                                      return DropdownMenuItem<String>(
                                        value: specialization,
                                        child: Text(specialization),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedSpecialization = value!;
                                      });
                                    },
                                    hint: Text('Select Specialization'),
                                    isExpanded: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Gender: '),
                                Radio<String>(
                                  value: 'All',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text('All'),
                                Radio<String>(
                                  value: 'Male',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text('Male'),
                                Radio<String>(
                                  value: 'Female',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                ),
                                Text('Female'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Session Fees: '),
                                Expanded(
                                  child: RangeSlider(
                                    min: 0,
                                    max: 1000,
                                    values: RangeValues(minSessionFees, maxSessionFees),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        minSessionFees = values.start;
                                        maxSessionFees = values.end;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:Colors.blue,
                                onPrimary: Colors.white
                              ),
                              onPressed: () {
                                filterDoctors();
                                Navigator.pop(context);
                              },
                              child: Text('Apply Filters'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.blue
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedName = '';
                                  selectedCity = '';
                                  selectedGender = 'All';
                                  selectedSpecialization = 'All';
                                  minSessionFees = 0;
                                  maxSessionFees = 1000;
                                });
                                filterDoctors();
                                Navigator.pop(context);
                              },
                              child: Text('Reset Filters'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                Doctor doctor = filteredDoctors[index];
                String imageUrl = (doctor.photoUrl.isEmpty || !doctor.photoUrl.contains('http'))
                    ? 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg'
                    : doctor.photoUrl; // Set a default image URL

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
            ),
    );
  }
}
