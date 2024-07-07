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
  int pageNumber = 1;
  final int pageSize = 10;
  String? clientName;
  String? startDate;
  String? endDate;
  String? status;

  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

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
          await DoctorsApi().fetchFilteredAppointments(
        clientName: clientName,
        startDate: startDate,
        endDate: endDate,
        status: status,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
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
    final String formattedDate =
        DateFormat.yMMMd().format(dateTime); // e.g., Jan 1, 2020
    final String formattedTime =
        DateFormat.jm().format(dateTime); // e.g., 6:00 AM
    return '$formattedDate at $formattedTime';
  }

  void handleSearch() {
    setState(() {
      clientName = clientNameController.text;
      startDate = startDateController.text;
      endDate = endDateController.text;
      pageNumber = 1; // Reset to first page for new search
    });
    fetchAppointments();
  }

  void resetFilters() {
    setState(() {
      clientNameController.text = '';
      startDateController.text = '';
      endDateController.text = '';
      status = null;
      clientName = null;
      startDate = null;
      endDate = null;
      status = null;
      pageNumber = 1; // Reset to first page for new search
    });
    fetchAppointments();
  }

  void goToPreviousPage() {
    if (pageNumber > 1) {
      setState(() {
        pageNumber--;
      });
      fetchAppointments();
    }
  }

  void goToNextPage() {
    setState(() {
      pageNumber++;
    });
    fetchAppointments();
  }

  void filterByStatus(String? selectedStatus) {
    setState(() {
      status = selectedStatus;
    });
    fetchAppointments();
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
              // Implement your search logic here (e.g., show search dialog)
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Search Appointments',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  clientName = value;
                                });
                              },
                              controller: clientNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter Client Name',
                                suffixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: startDateController,
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2025),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        startDateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        startDate = DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: endDateController,
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2025),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        endDateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        endDate = DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: status,
                              hint: Text("Status"),
                              onChanged: (String? value) {
                                setState(() {
                                  status = value ?? 'All';
                                });
                              },
                              items: <String>[
                                'All',
                                'Confirmed',
                                'Pending',
                                'Rejected',
                                'Cancelled'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () {
                                    handleSearch();
                                    Navigator.of(context)
                                        .pop(); // Close bottom sheet
                                  },
                                  child: Text('Search'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () {
                                    resetFilters();
                                    Navigator.of(context)
                                        .pop(); // Close bottom sheet
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
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Appointments List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: appointments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == appointments.length) {
                        // Pagination arrows
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (pageNumber > 1)
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: goToPreviousPage,
                              ),
                            SizedBox(width: 16),
                            TextButton(
                              onPressed: null,
                              child: Text('Page $pageNumber'),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: appointments.length == pageSize
                                  ? goToNextPage
                                  : null,
                            ),
                          ],
                        );
                      }
                      final appointment = appointments[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(appointment['clientPhotoUrl']),
                            ),
                            title: Text(
                              appointment['clientName'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  'Start Time: ${_formatDateTime(appointment['startTime'])}',
                                ),
                                Text(
                                  'End Time: ${_formatDateTime(appointment['endTime'])}',
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Status: ${appointment['status']}',
                                  style: TextStyle(
                                    color: appointment['status'] == 'Pending'
                                        ? Colors.orange
                                        : appointment['status'] == 'Rejected'
                                            ? Colors.red
                                            : appointment['status'] ==
                                                    'Confirmed'
                                                ? Colors.green
                                                : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (appointment['status'] == 'Rejected' &&
                                    appointment['rejectionReason'] != null)
                                  Text(
                                    'Rejection Reason: ${appointment['rejectionReason']}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                            trailing: appointment['status'] == 'Pending'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check,
                                            color: Colors.green),
                                        onPressed: () => confirmAppointment(
                                            appointment['id'].toString()),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController
                                                  rejectionReasonController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title:
                                                    Text('Reject Appointment'),
                                                content: TextField(
                                                  controller:
                                                      rejectionReasonController,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter rejection reason'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      rejectAppointment(
                                                          appointment['id']
                                                              .toString(),
                                                          rejectionReasonController
                                                              .text);
                                                      Navigator.of(context)
                                                          .pop();
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
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
