import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart';
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/Doctors/DoctorDetailview.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';

class Doctorsview extends StatefulWidget {
  final String userId;
  const Doctorsview({required this.userId});

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<Doctorsview> {
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
        bool matchesGender =
            selectedGender == 'All' || doctor.gender == selectedGender;
        bool matchesName = selectedName.isEmpty ||
            doctor.fullName.toLowerCase().contains(selectedName.toLowerCase());
        bool matchesFees = doctor.sessionFees >= minSessionFees &&
            doctor.sessionFees <= maxSessionFees;
        bool matchesSpecialization = selectedSpecialization == 'All' ||
            doctor.specialization == selectedSpecialization;
        bool matchesCity = selectedCity.isEmpty ||
            doctor.city.toLowerCase().contains(selectedCity.toLowerCase());
        return matchesGender &&
            matchesName &&
            matchesFees &&
            matchesSpecialization &&
            matchesCity;
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
              setState(() {
                selectedName = '';
                selectedCity = '';
                selectedGender = 'All';
                selectedSpecialization = 'All';
                minSessionFees = 0;
                maxSessionFees = 1000;
              });
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
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
                                  Text(
                                    'Gender: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: selectedGender,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedGender = newValue!;
                                        });
                                      },
                                      items: <String>['All', 'Male', 'Female']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Specialization: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: selectedSpecialization,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedSpecialization = newValue!;
                                        });
                                      },
                                      items: specializations
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Session Fees: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Expanded(
                                    child: RangeSlider(
                                      values: RangeValues(
                                          minSessionFees, maxSessionFees),
                                      min: 0,
                                      max: 1000,
                                      divisions: 100,
                                      labels: RangeLabels(
                                        minSessionFees.toString(),
                                        maxSessionFees.toString(),
                                      ),
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
                                  primary: Color(0xff0074F1),
                                  onPrimary: Colors.white,
                                ),
                                onPressed: () {
                                  filterDoctors();
                                  Navigator.pop(context);
                                },
                                child: Text('Apply Filters'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedName = '';
                                    selectedCity = '';
                                    selectedGender = 'All';
                                    selectedSpecialization = 'All';
                                    minSessionFees = 0;
                                    maxSessionFees = 1000;
                                  });
                                  fetchDoctorsData();
                                  Navigator.pop(context);
                                },
                                child: Text('Reset Filters'),
                              ),
                            ],
                          ),
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
      drawer: CommonDrawer(userId: widget.userId),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                Doctor doctor = filteredDoctors[index];
                String imageUrl = (doctor.photoUrl.isEmpty ||
                        !doctor.photoUrl.contains('http'))
                    ? 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg'
                    : doctor.photoUrl; // Set a default image URL

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailview(doctor: doctor),
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
