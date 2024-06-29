import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/AppointmentApi.dart';
import 'package:mentalhealthh/models/appointment.dart';
import 'package:mentalhealthh/authentication/auth.dart';

class Appointmentsview extends StatefulWidget {
  @override
  _AppointmentsviewState createState() => _AppointmentsviewState();
}

class _AppointmentsviewState extends State<Appointmentsview> {
  final BookingApi bookingApi = BookingApi();
  List<Appointment> appointments = [];
  List<Appointment> filteredAppointments = [];
  bool isLoading = false;
  String selectedStatus = 'All';
  String doctorName = '';
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    userId = await Auth.getUserId();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newAppointments = await bookingApi.getAppointments(pageNumber: 1, pageSize: 10);

      setState(() {
        appointments = newAppointments;
        filteredAppointments = newAppointments;
      });
    } catch (error) {
      print('Error fetching appointments: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _searchAppointments({String? status, String? doctorName}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final searchedAppointments = await bookingApi.searchAppointments(
        status: status == 'All' ? null : status,
        doctorName: doctorName,
      );

      setState(() {
        filteredAppointments = searchedAppointments;
      });
    } catch (error) {
      print('Error searching appointments: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
   String _formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formattedDate =
        DateFormat.yMMMd().format(dateTime); // e.g., Jan 1, 2020
    final String formattedTime =
        DateFormat.jm().format(dateTime); // e.g., 6:00 AM
    return '$formattedDate at $formattedTime';
  }

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String? newStatus = selectedStatus;
        String newDoctorName = doctorName;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: newStatus,
                    items: <String>[
                      'All',
                      'Pending',
                      'Cancelled',
                      'Rejected',
                      'Confirmed'
                    ].map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        newStatus = value!;
                      });
                    },
                    hint: Text('Select Status'),
                    isExpanded: true,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Doctor Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        newDoctorName = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStatus = newStatus!;
                        doctorName = newDoctorName;
                      });
                      _searchAppointments(
                        status: selectedStatus == 'All' ? null : selectedStatus,
                        doctorName: doctorName.isEmpty ? null : doctorName,
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStatus = 'All';
                        doctorName = '';
                      });
                      _searchAppointments();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchModal,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredAppointments.isEmpty
              ? Center(child: Text('No appointments found'))
              : ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = filteredAppointments[index];
                    Color cardColor;
                    String imageUrl = (appointment.doctorPhotoUrl.isEmpty || !appointment.doctorPhotoUrl.contains('http'))
                        ? 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg'
                        : appointment.doctorPhotoUrl;
                    String? reason;

                    switch (appointment.status) {
                      case 'Cancelled':
                        cardColor = Color(0xffDADADA);
                        reason = appointment.cancellationReason;
                        break;
                      case 'Rejected':
                        cardColor = Color.fromARGB(255, 229, 112, 103);
                        reason = appointment.rejectionReason;
                        break;
                      case 'Confirmed':
                        cardColor = Color.fromARGB(255, 90, 198, 90);
                        reason = null;
                        break;
                      default:
                        cardColor = Color.fromARGB(255, 225, 209, 59);
                        reason = null;
                    }

                    final formattedDateTime = _formatDateTime(appointment.startTime);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 40,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.doctorName,
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      Text(formattedDateTime),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text('Duration: ${appointment.duration}'),
                              Text('Fees: ${appointment.fees}\$'),
                              Text('Status: ${appointment.status}'),
                              Text('Location: ${appointment.location}'),
                              if (reason != null) Text('Reason: $reason'),
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
