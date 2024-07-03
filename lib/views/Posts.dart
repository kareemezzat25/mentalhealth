import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
import 'package:mentalhealthh/views/PostComment.dart';
import 'package:mentalhealthh/widgets/forum.dart';
import 'package:mentalhealthh/services/postsApi.dart';

class Posts extends StatefulWidget {
  final String? userId;
  final bool showUserPosts;
  final bool? confessionsOnly;

  Posts(
      {Key? key, this.userId, this.showUserPosts = false, this.confessionsOnly})
      : super(key: key);

  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {
  late Future<List<Map<String, dynamic>>> posts;
  int currentPage = 1;
  int pageSize = 30;
  String userId = "";
  bool hasMoreData = true;

  String? titleFilter;
  String? contentFilter;
  String? usernameFilter;
  DateTime? startTimeFilter;
  DateTime? endTimeFilter;

  Future<void> _refreshPosts() async {
    setState(() {
      // Fetching posts with updated filters
      posts = widget.showUserPosts && widget.userId != null
          ? PostsApi.fetchUserPosts(widget.userId!, currentPage, pageSize)
          : widget.confessionsOnly != null
              ? PostsApi.fetchPaginatedPosts(
                  currentPage,
                  pageSize,
                  confessionsOnly: widget.confessionsOnly!,
                  title: titleFilter,
                  content: contentFilter,
                  username: usernameFilter,
                  startTime: startTimeFilter,
                  endTime: endTimeFilter,
                )
              : PostsApi.fetchPaginatedPosts(
                  currentPage,
                  pageSize,
                  title: titleFilter,
                  content: contentFilter,
                  username: usernameFilter,
                  startTime: startTimeFilter,
                  endTime: endTimeFilter,
                );
      posts.then((data) {
        setState(() {
          hasMoreData = data.length == pageSize;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();
    posts = widget.showUserPosts && widget.userId != null
        ? PostsApi.fetchUserPosts(widget.userId!, currentPage, pageSize)
        : widget.confessionsOnly != null
            ? PostsApi.fetchPaginatedPosts(currentPage, pageSize,
                confessionsOnly: widget.confessionsOnly!)
            : PostsApi.fetchPaginatedPosts(currentPage, pageSize);
    posts.then((data) {
      setState(() {
        hasMoreData = data.length == pageSize;
      });
    });
  }

  Future<void> initUser() async {
    String? fetchedUserId = await Auth.getUserId();
    setState(() {
      userId = fetchedUserId ?? "";
    });
  }

  Future<void> _loadNextPage() async {
    setState(() {
      currentPage++;
      _refreshPosts();
    });
  }

  Future<void> _loadPreviousPage() async {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        _refreshPosts();
      });
    }
  }

  void _applyFilters() {
    Navigator.pop(context); // Close the bottom sheet
    _refreshPosts();
  }

  void _openFilterBottomSheet() {
    // Reset filter values before opening the bottom sheet
    setState(() {
      titleFilter = null;
      contentFilter = null;
      usernameFilter = null;
      startTimeFilter = null;
      endTimeFilter = null;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Filter Posts',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) => titleFilter = value,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  onChanged: (value) => contentFilter = value,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  onChanged: (value) => usernameFilter = value,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startTimeFilter ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              startTimeFilter = pickedDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: startTimeFilter != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(startTimeFilter!)
                                  : '',
                            ),
                            decoration: InputDecoration(
                              labelText: 'Start Time',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: endTimeFilter ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              endTimeFilter = pickedDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: endTimeFilter != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(endTimeFilter!)
                                  : '',
                            ),
                            decoration: InputDecoration(
                              labelText: 'End Time',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _resetFilters,
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.blue,
                      ),
                      child: Text('Reset Filters'),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Apply Filters'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      titleFilter = null;
      contentFilter = null;
      usernameFilter = null;
      startTimeFilter = null;
      endTimeFilter = null;
    });
    Navigator.pop(context); // Close the bottom sheet after resetting filters

    _refreshPosts(); // Refresh posts after resetting filters
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ForumsPage(userId: userId);
        }));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _openFilterBottomSheet(); // Open filter bottom sheet
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPosts,
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: posts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Map<String, dynamic>> postsData =
                          snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: postsData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              String? refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostComment(
                                    postId: postsData[index]['id'],
                                    userId: userId,
                                  ),
                                ),
                              );
                              if (refresh == "refresh") {
                                _refreshPosts();
                              }
                            },
                            child:Forum(
                              postId: postsData[index]['id'].toString(),
                              postTitle: postsData[index]['title'],
                              postContent: postsData[index]['content'],
                              username: postsData[index]['username'],
                              postedOn: postsData[index]['postedOn'],
                              appUserId: postsData[index]['appUserId'],
                              isAnonymous: postsData[index]['isAnonymous'],
                              userId: userId,
                              photoUrl: postsData[index]['photoUrl'],
                              postPhotoUrl: postsData[index]['postPhotoUrl'],
                              commentsCount: postsData[index]['commentsCount'],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentPage > 1)
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: _loadPreviousPage,
                        ),
                      Text('Page $currentPage'),
                      if (hasMoreData)
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: _loadNextPage,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}






