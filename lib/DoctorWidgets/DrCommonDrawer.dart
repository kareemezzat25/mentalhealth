import 'package:flutter/material.dart';
import 'package:mentalhealthh/DoctorViews/notifications/DoctorNotificationsview.dart';
import 'package:mentalhealthh/DoctorViews/schedules/Scheduleview.dart';
import 'package:mentalhealthh/models/user_model.dart';
import 'package:mentalhealthh/views/appointments/DoctorAppointmentsview.dart';
import 'package:mentalhealthh/views/Profiles/UserProfile.dart';
import 'package:mentalhealthh/views/authentication/loginview.dart';
import 'package:provider/provider.dart';
import 'package:mentalhealthh/Providers/doctor_notification_count_provider.dart';

class DrCommonDrawer extends StatelessWidget {
  final String doctorId;

  DrCommonDrawer({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context); // Access UserModel
    DoctorNotificationCountProvider notificationProvider =
        Provider.of<DoctorNotificationCountProvider>(
            context); // Access DoctorNotificationCountProvider

    return Drawer(
      width: 200,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffCAE7EF),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Colors.grey, style: BorderStyle.solid),
                      image: userModel.photoUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(userModel.photoUrl),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                  'assets/images/Memoji Boys 3-15.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            userModel.userName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Flexible(
                          child: Text(
                            userModel.userEmail,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Schedule"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SchedulePage(
                          doctorId: doctorId,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule_outlined),
            title: Text('Appointments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DoctorAppointmentsPage()),
              );
            },
          ),
          Consumer<DoctorNotificationCountProvider>(
            builder: (context, notificationCountProvider, _) => ListTile(
              leading: Stack(
                children: [
                  Icon(Icons.notifications),
                  if (notificationCountProvider.unreadCount > 0)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          '${notificationCountProvider.unreadCount}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorNotificationsview(),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text("Doctor Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDoctorProfile(
                    userId: doctorId,
                    roles: ['Doctor'], // Pass doctor role
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: ListTile(
              tileColor: Color(0xff000000),
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
