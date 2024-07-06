import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/Appointmentapi.dart';
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
  int pageNumber = 1; // Track current page number
  final int pageSize = 10; // Number of items per page

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
          await DoctorsApi().fetchDoctorAppointments(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
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
      showSnackBar('Failed to fetch appointments');
    }
  }

  Future<void> applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> filtered =
          await DoctorsApi().fetchFilteredAppointments(
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
      showSnackBar('Failed to apply filters');
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
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filter Appointments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  onChanged: (String? value) {
                    setState(() {
                      selectedStatus = value ?? 'All';
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
                  decoration: InputDecoration(
                    labelText: 'Select Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startDate != null
                                ? DateTime.parse(startDate!)
                                : DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              startDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller:
                                TextEditingController(text: startDate),
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: endDate != null
                                ? DateTime.parse(endDate!)
                                : DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              endDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller:
                                TextEditingController(text: endDate),
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        applyFilters();
                      },
                      child: Text('Apply Filters'),
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
}


  Future<void> confirmAppointment(String appointmentId) async {
    try {
      await BookingApi().confirmAppointment(appointmentId);
      fetchAppointments();
      showSnackBar('Appointment confirmed successfully');
    } catch (error) {
      print('Error confirming appointment: $error');
      showSnackBar('Failed to confirm appointment');
    }
  }

  Future<void> rejectAppointment(String appointmentId, String reason) async {
    try {
      await BookingApi().rejectAppointment(appointmentId, reason);
      fetchAppointments();
      showSnackBar('Appointment rejected successfully');
    } catch (error) {
      print('Error rejecting appointment: $error');
      showSnackBar('Failed to reject appointment');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _loadNextPage() {
    setState(() {
      pageNumber++;
    });
    fetchAppointments();
  }

  void _loadPreviousPage() {
    if (pageNumber > 1) {
      setState(() {
        pageNumber--;
      });
      fetchAppointments();
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
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = filteredAppointments[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      appointment['clientPhotoUrl']),
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
                                        color:
                                            appointment['status'] == 'Pending'
                                                ? Colors.orange
                                                : appointment['status'] ==
                                                        'Rejected'
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
                                              appointment['id'].toString(),
                                            ),
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
                                                    title: Text(
                                                        'Reject Appointment'),
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
                                                                .text,
                                                          );
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
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: _loadPreviousPage,
                        ),
                        Text('Page $pageNumber'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: _loadNextPage,
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
