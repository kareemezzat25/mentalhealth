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
      final newAppointments = await bookingApi.getAppointments(
        pageNumber: 1,
        pageSize: 10,
        doctorName: doctorName.isNotEmpty ? doctorName : null,
        status: selectedStatus != 'All' ? selectedStatus : null,
      );

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

  void _resetFilters() {
    setState(() {
      selectedStatus = 'All';
      doctorName = '';
    });
    _fetchAppointments(); // Refresh appointments with cleared filters
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
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                onChanged: (String? value) {
                  setState(() {
                    selectedStatus = value ?? 'All';
                  });
                },
                items: <String>[
                  'All',
                  'Pending',
                  'Cancelled',
                  'Rejected',
                  'Confirmed'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Status',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    doctorName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Doctor Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                      _fetchAppointments(); // Apply filters and refresh
                    },
                    child: Text('Apply Filter'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                      _resetFilters(); // Reset filters
                    },
                    child: Text('Reset Filters'),
                  ),
                ],
              ),
            ],
          ),
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
            onPressed: () {
              _showSearchModal();
            },
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
                    String imageUrl = (appointment.doctorPhotoUrl.isEmpty ||
                            !appointment.doctorPhotoUrl.contains('http'))
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

                    final formattedDateTime =
                        _formatDateTime(appointment.startTime);

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.doctorName,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
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
