import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String? username;
  final String? postedOn;
  final bool? isAnonymous;
  final String? photoUrl; // Add the photoUrl parameter

  UserInfo({this.username, this.postedOn, this.isAnonymous, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: Row(
        children: [
          if (!isAnonymous!)
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl ?? ''), // Use the photoUrl
            ),
          if (isAnonymous!)
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/anonymous.png'),
            ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAnonymous! ? 'Anonymous' : (username ?? ''),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                calculateTimeDifference(postedOn!),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String calculateTimeDifference(String postDateTime) {
    DateTime postTime = DateTime.parse(postDateTime);

    DateTime adjustedPostTime = postTime.add(Duration(hours: 3));

    Duration difference = DateTime.now().difference(adjustedPostTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year ago' : 'years ago'}';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month ago' : 'months ago'}';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? 'week ago' : 'weeks ago'}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day ago' : 'days ago'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour ago' : 'hours ago'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute ago' : 'minutes ago'}';
    } else {
      return 'now';
    }
  }
}
