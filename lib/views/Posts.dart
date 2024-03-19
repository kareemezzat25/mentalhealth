import 'package:flutter/material.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
//import 'package:mentalhealthh/views/MainHomeview.dart';
import 'package:mentalhealthh/views/PostComment.dart';
import 'package:mentalhealthh/widgets/forum.dart';
import 'package:mentalhealthh/api/postsApi.dart';

class Posts extends StatefulWidget {
  @override
  _Posts createState() => _Posts();
}

class _Posts extends State<Posts> {
  late Future<List<Map<String, dynamic>>> posts;
  late String userId;
  int currentPage = 1;
  int pageSize = 30;
  double maxHeight = 200.0; // Set the maximum height for the container

  void changeData() {
    setState(() {
      _refreshPosts();
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      posts = PostsApi.fetchPaginatedPosts(currentPage, pageSize);
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();
    posts = PostsApi.fetchPaginatedPosts(currentPage, pageSize);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ForumsPage(userId: "123");
        }));
        return false; // prevent default behavior
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Posts'),
        // ),
        body: RefreshIndicator(
          onRefresh: _refreshPosts,
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: posts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      List<Map<String, dynamic>> postsData =
                          snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: postsData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              String? refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostComment(
                                    postId: postsData[index]['id'],
                                    userId: userId,
                                    appUserId: postsData[index]['appUserId'],
                                  ),
                                ),
                              );

                              if (true) {
                                changeData();
                              }
                            },
                            child: Container(
                              height: 310,
                              child: Forum(
                                postId: postsData[index]['id'].toString(),
                                postTitle: postsData[index]['title'],
                                postContent: postsData[index]['content'],
                                username: postsData[index]['username'],
                                postedOn: postsData[index]['postedOn'],
                                appUserId: postsData[index]['appUserId'],
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // Row with page number and arrow buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentPage != 1)
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _loadPreviousPage,
                      ),
                    Text('Page $currentPage'),
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
