import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/AppointmentApi.dart';
import 'package:mentalhealthh/models/appointment.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';

class Appointmentsview extends StatefulWidget {
    final String userId;
      Appointmentsview({required this.userId}); // Add userId parameter
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
  int pageNumber = 1; // Track current page number
  final int pageSize = 10; // Number of items per page

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
        pageNumber: pageNumber,
        pageSize: pageSize,
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

  void _cancelAppointment(Appointment appointment) async {
    String cancellationReason = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Are you sure you want to cancel this appointment?'),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  cancellationReason = value;
                },
                decoration: InputDecoration(
                  labelText: 'Cancellation Reason (Optional)',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                // Call API to cancel appointment
                try {
                  await bookingApi.cancelAppointment(
                      appointment.id, cancellationReason);
                  // Refresh appointments after cancellation
                  _fetchAppointments();
                } catch (error) {
                  print('Error cancelling appointment: $error');
                  // Handle error as needed
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadNextPage() {
    setState(() {
      pageNumber++;
    });
    _fetchAppointments();
  }

  void _loadPreviousPage() {
    if (pageNumber > 1) {
      setState(() {
        pageNumber--;
      });
      _fetchAppointments();
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Cancelled':
        return Colors.grey; // Adjust color for Cancelled status
      case 'Rejected':
        return Colors.red; // Adjust color for Rejected status
      case 'Confirmed':
        return Colors.green; // Adjust color for Confirmed status
      default:
        return Colors.orange; // Default color for other statuses
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
            onPressed: () {
              _showSearchModal();
            },
          ),
        ],
      ),
      drawer: CommonDrawer(userId: widget.userId),
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
                          String imageUrl = (appointment.doctorPhotoUrl.isEmpty ||
                                  !appointment.doctorPhotoUrl.contains('http'))
                              ? 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg'
                              : appointment.doctorPhotoUrl;
                          String? reason;

                          switch (appointment.status) {
                            case 'Cancelled':
                              reason = appointment.cancellationReason;
                              break;
                            case 'Rejected':
                              reason = appointment.rejectionReason;
                              break;
                            default:
                              reason = null;
                              break;
                          }

                          final formattedDateTime =
                              _formatDateTime(appointment.startTime);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Color(0xffFFFFFF),
                              elevation: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(imageUrl),
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(formattedDateTime),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text('Duration: ${appointment.duration}'),
                                    Text('Fees: ${appointment.fees}\$'),
                                    Text(
                                      'Status: ${appointment.status}',
                                      style: TextStyle(
                                        color: _getStatusTextColor(appointment.status),
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text('Location: ${appointment.location}'),
                                    if (reason != null) Text('Reason: $reason'),
                                    if (appointment.status == 'Pending' ||
                                        appointment.status == 'Confirmed')
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                            onPrimary: Colors.white,
                                          ),
                                          onPressed: () {
                                            _cancelAppointment(appointment);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(pageNumber>1)
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
