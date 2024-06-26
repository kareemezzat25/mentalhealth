import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/AppointmentApi.dart'; // Update the path accordingly
import 'package:mentalhealthh/models/appointment.dart'; // Ensure this path is correct

class Appointmentsview extends StatefulWidget {
  @override
  _AppointmentsviewState createState() => _AppointmentsviewState();
}

class _AppointmentsviewState extends State<Appointmentsview> {
  final BookingApi bookingApi = BookingApi();
  List<Appointment> appointments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
      });
    } catch (error) {
      print('Error fetching appointments: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formattedDate = DateFormat.yMMMd().format(dateTime); // e.g., Jan 1, 2020
    final String formattedTime = DateFormat.jm().format(dateTime); // e.g., 6:00 AM
    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : appointments.isEmpty
              ? Center(child: Text('No appointments found'))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    Color cardColor;
                    String imageUrl = appointment.doctorPhotoUrl.isNotEmpty
                        ? appointment.doctorPhotoUrl
                        : 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg';
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
                        cardColor = Color(0xff90EE90);
                        reason = null;
                        break;
                      default:
                        cardColor = Color(0xffFFFFE0);
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
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
