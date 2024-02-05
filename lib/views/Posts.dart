import 'package:flutter/material.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/PostComment.dart';
import 'package:mentalhealthh/widgets/forum.dart';
import 'package:mentalhealthh/api/postsApi.dart';

class Posts extends StatefulWidget {
  @override
  _Posts createState() => _Posts();
}

class _Posts extends State<Posts> {
  late Future<List<Map<String, dynamic>>> posts;
  late String userId; // Add this line
  bool value = false;

  void changeData() {
    setState(() {
      _refreshPosts();
      //posts = PostsApi.fetchPosts();
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      posts = PostsApi.fetchPosts();
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();
    posts = PostsApi.fetchPosts();
  }

  Future<void> initUser() async {
    String? fetchedUserId = await Auth.getUserId();
    setState(() {
      userId = fetchedUserId ?? "";
    });
  }

  // Future<void> _deletePost(String postId) async {
  //   try {
  //     // Delete post and fetch updated posts
  //     await PostsApi.deletePost(postId);
  //     _refreshPosts();
  //   } catch (error) {
  //     // Handle errors
  //     print('Error during post deletion: $error');
  //     // You may want to show an error message to the user
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
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
            List<Map<String, dynamic>> postsData = snapshot.data ?? [];
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
                          appUserId: postsData[index]['appUserId'],
                        ),
                      ),
                    );

                    if (true) {
                      changeData();
                    }
                  },
                  child: Container(
                    height: 550,
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
    );
  }
}
