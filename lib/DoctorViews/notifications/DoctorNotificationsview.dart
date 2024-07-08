import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/services/notificationsapi.dart';
import 'package:provider/provider.dart';
import 'package:mentalhealthh/views/appointments/DoctorAppointmentsview.dart';
import 'package:mentalhealthh/views/posts/PostComment.dart';
import 'package:mentalhealthh/providers/notification_count_provider.dart';
import 'package:mentalhealthh/services/postsApi.dart';

class DoctorNotificationsview extends StatefulWidget {
  @override
  _DoctorNotificationsPageState createState() =>
      _DoctorNotificationsPageState();
}

class _DoctorNotificationsPageState extends State<DoctorNotificationsview> {
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> filteredNotifications = [];
  bool isLoading = false;
  bool showUnreadOnly = false;
  int pageNumber = 1;
  int pageSize = 10;
  bool hasMoreData = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNotifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final List<Map<String, dynamic>> newNotifications =
          await NotificationsApi.fetchNotifications(pageNumber, pageSize);

      setState(() {
        if (newNotifications.isEmpty) {
          hasMoreData = false;
        } else {
          notifications.addAll(newNotifications);
          pageNumber++;
        }
        filteredNotifications = showUnreadOnly
            ? notifications
                .where((notification) => !notification['isRead'])
                .toList()
            : notifications;

        Provider.of<NotificationCountProvider>(context, listen: false)
            .updateUnreadCount(notifications
                .where((notification) => !notification['isRead'])
                .length);
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await NotificationsApi.markAsRead(id);
      setState(() {
        notifications = notifications.map((notification) {
          if (notification['id'] == id) {
            notification['isRead'] = true;
          }
          return notification;
        }).toList();

        filteredNotifications = showUnreadOnly
            ? notifications
                .where((notification) => !notification['isRead'])
                .toList()
            : notifications;

        Provider.of<NotificationCountProvider>(context, listen: false)
            .updateUnreadCount(notifications
                .where((notification) => !notification['isRead'])
                .length);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await NotificationsApi.markAllAsRead();
      setState(() {
        notifications = notifications.map((notification) {
          notification['isRead'] = true;
          return notification;
        }).toList();
        filteredNotifications = notifications;
        Provider.of<NotificationCountProvider>(context, listen: false)
            .updateUnreadCount(0);
      });
    } catch (e) {
      print(e);
    }
  }

  void toggleUnreadOnly() {
    setState(() {
      showUnreadOnly = !showUnreadOnly;
      filteredNotifications = showUnreadOnly
          ? notifications
              .where((notification) => !notification['isRead'])
              .toList()
          : notifications;
    });
  }

  String _formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final String formattedDate = DateFormat('d/M/y').format(dateTime);
    final String formattedTime = DateFormat.jm().format(dateTime);
    return '$formattedDate at $formattedTime';
  }

  void _handleNotificationTap(Map<String, dynamic> notification) async {
    if (!notification['isRead']) {
      markAsRead(notification['id']);
    }

    try {
      if (notification['type'] == 'Reply') {
        int postId = notification['resources']['postId'];
        int commentId = notification['resources']['commentId'];
        int replyId = notification['resources']['replyId'];
        try {
          // Attempt to fetch post details
          Map<String, dynamic> postDetails =
              await PostsApi.fetchPostDetails(postId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostComment(
                postId: postId,
              ),
            ),
          );
        } catch (e) {
          // Post details fetch failed (post deleted)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Deleted'),
                content:
                    Text('The post you are trying to view has been deleted.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else if (notification['type'] == 'AppointmentRequest' ||
          notification['type'] == 'AppointmentCancellation') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorAppointmentsPage()),
        );
      } else if (notification['type'] == 'Comment') {
        int postId = notification['resources']['postId'];
        try {
          // Attempt to fetch post details
          Map<String, dynamic> postDetails =
              await PostsApi.fetchPostDetails(postId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostComment(
                postId: postId,
              ),
            ),
          );
        } catch (e) {
          // Post details fetch failed (post deleted)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Post Deleted'),
                content:
                    Text('The post you are trying to view has been deleted.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error: Exception: $e');
    }
  }

  void loadNextPage() {
    if (hasMoreData && !isLoading) {
      fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: Text(
              'Mark All as Read',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: toggleUnreadOnly,
            child: Text(
              showUnreadOnly ? 'Show All' : 'Unread Only',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: isLoading && notifications.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        filteredNotifications.length + (hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < filteredNotifications.length) {
                        final notification = filteredNotifications[index];
                        final formattedDateTime =
                            _formatDateTime(notification['dateCreated']);

                        return Container(
                          color: notification['isRead']
                              ? Colors.purple.shade50
                              : Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  notification['notifierPhotoUrl']),
                            ),
                            title: Text(notification['notifierUserName']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['message'],
                                  style: TextStyle(fontSize: 17),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 48.0),
                                  child: Text('$formattedDateTime'),
                                ),
                              ],
                            ),
                            trailing: notification['isRead']
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.check_circle_outline,
                                    color: Colors.grey),
                            onTap: () {
                              _handleNotificationTap(notification);
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
