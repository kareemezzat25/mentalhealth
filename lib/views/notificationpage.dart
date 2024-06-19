import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRPage extends StatefulWidget {
  @override
  _SignalRPageState createState() => _SignalRPageState();
}

class _SignalRPageState extends State<SignalRPage> {
  final serverUrl = "https://nexus-api-h3ik.onrender.com/notification-hub";
  late HubConnection hubConnection;


  void _handleNotification(List<Object?> args) {
  if (args.isNotEmpty) {
    final notification = args.first as Map<String, dynamic>;
    print(notification['message']);
  }
  }


 /* @override
  void initState() {
    super.initState();
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.onclose((error) {
    } as ClosedCallback);
    hubConnection.on("ReceiveNotification",_handleNotification);
    _startConnection();
  }
*/
  Future<void> _startConnection() async {
    try {
      await hubConnection.start();
      print("Connection Started");
    } catch (error) {
      print("Error starting connection: $error");
      // Handle connection error
    }
  }
  @override
  void dispose() {
    hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}