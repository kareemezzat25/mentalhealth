import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart';
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/DoctorDetailPage.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';

class DoctorsPage extends StatefulWidget {
  final String userId;
  const DoctorsPage({ required this.userId});


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
                            // Other filter widgets
                            ElevatedButton(
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
