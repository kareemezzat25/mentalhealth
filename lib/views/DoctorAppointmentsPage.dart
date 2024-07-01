import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/doctorapi.dart';

class DoctorAppointmentsPage extends StatefulWidget {
  @override
  _DoctorAppointmentsPageState createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> filteredAppointments = [];
  String selectedStatus = 'All';
  String clientName = '';
  String? startDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> fetchedAppointments =
          await DoctorsApi().fetchDoctorAppointments();
      setState(() {
        appointments = fetchedAppointments;
        filteredAppointments = fetchedAppointments;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching appointments: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> applyFilters() async {
  setState(() {
    isLoading = true;
  });

  try {
    List<Map<String, dynamic>> filtered = await DoctorsApi().fetchFilteredAppointments(
      clientName: clientName.isNotEmpty ? clientName : null,
      startDate: startDate,
      endDate: endDate,
      status: selectedStatus != 'All' ? selectedStatus : null,
    );
    setState(() {
      filteredAppointments = filtered;
    });
  } catch (error) {
    print('Error fetching filtered appointments: $error');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  void resetFilters() {
    setState(() {
      selectedStatus = 'All';
      clientName = '';
      startDate = null;
      endDate = null;
    });
    fetchAppointments();
  }

  String _formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formattedDate = DateFormat.yMMMd().format(dateTime); // e.g., Jan 1, 2020
    final String formattedTime = DateFormat.jm().format(dateTime); // e.g., 6:00 AM
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
                items: <String>['All', 'Confirmed', 'Pending', 'Rejected', 'Cancelled']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    clientName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Client Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Start Date (yyyy-MM-dd)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    startDate = value; // Ensure this is formatted as yyyy-MM-dd
                  });
                },
              ),

              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'End Date (yyyy-mm-dd)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    endDate = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      applyFilters();
                    },
                    child: Text('Apply Filter'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      resetFilters();
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

  Future<void> confirmAppointment(String appointmentId) async {
    try {
      await DoctorsApi().confirmAppointment(appointmentId);
      fetchAppointments();
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
      fetchAppointments();
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(appointment['clientPhotoUrl']),
                      ),
                      title: Text(appointment['clientName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time: ${_formatDateTime(appointment['startTime'])}'),
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
                              onPressed: () => confirmAppointment(appointment['id'].toString()),
                            ),
                          if (appointment['status'] == 'Pending')
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController rejectionReasonController = TextEditingController();
                                    return AlertDialog(
                                      title: Text('Reject Appointment'),
                                      content: TextField(
                                        controller: rejectionReasonController,
                                        decoration: InputDecoration(hintText: 'Enter rejection reason'),
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
                                              rejectionReasonController.text,
                                            );
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
