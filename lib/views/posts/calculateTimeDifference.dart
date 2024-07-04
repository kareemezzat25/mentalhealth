class CalculateTimeDifference {
// Add this function outside the build method
  String calculateTimeDifference(String postDateTime) {
    DateTime postTime = DateTime.parse(postDateTime);

    // Consider UTC+2 time zone offset (2 hours)
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
