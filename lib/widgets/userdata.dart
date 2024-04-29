import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String? username;
  final String? postedOn;
  final bool? isAnonymous;

  UserInfo({
    required this.username,
     this.postedOn,
    required this.isAnonymous,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Conditionally display user image or Icon based on isAnonymous
            isAnonymous == true
                ? Icon(Icons.account_circle_outlined, size: 40)
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/Illustration.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isAnonymous == true ? 'Anonymous' : username ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  calculateTimeDifference(postedOn!),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
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
    } else
      return 'now';
  }
}
