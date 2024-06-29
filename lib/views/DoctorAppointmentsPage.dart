import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/doctorapi.dart'; // Replace with your actual path

class DoctorAppointmentsPage extends StatefulWidget {
  @override
  _DoctorAppointmentsPageState createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      List<Map<String, dynamic>> fetchedAppointments =
          await DoctorsApi().fetchDoctorAppointments();
      setState(() {
        appointments = fetchedAppointments;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching appointments: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmAppointment(String appointmentId) async {
    try {
      await DoctorsApi().confirmAppointment(appointmentId);
      fetchAppointments(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment confirmed successfully')),
      );
    } catch (error) {
      print('Error confirming appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm appointment')),
      );
    }
  }

  Future<void> rejectAppointment(String appointmentId, String reason) async {
    try {
      await DoctorsApi().rejectAppointment(appointmentId, reason);
      fetchAppointments(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment rejected successfully')),
      );
    } catch (error) {
      print('Error rejecting appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject appointment')),
      );
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
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(appointment['clientPhotoUrl']),
                  ),
                  title: Text(appointment['clientName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time:${_formatDateTime(appointment['startTime'])}'),
                       Text('${_formatDateTime(appointment['endTime'])}'),
                      Text('Status: ${appointment['status']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (appointment['status'] == 'Pending')
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () =>
                              confirmAppointment(appointment['id'].toString()),
                        ),
                      if (appointment['status'] == 'Pending')
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController
                                    rejectionReasonController =
                                    TextEditingController();
                                return AlertDialog(
                                  title: Text('Reject Appointment'),
                                  content: TextField(
                                    controller: rejectionReasonController,
                                    decoration: InputDecoration(
                                        hintText: 'Enter rejection reason'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        rejectAppointment(
                                            appointment['id'].toString(),
                                            rejectionReasonController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Reject'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
