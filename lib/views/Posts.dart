import 'package:flutter/material.dart';
import 'package:mentalhealthh/widgets/forum.dart';
import 'package:mentalhealthh/api/postsApi.dart';

class Posts extends StatefulWidget {
  @override
  _Posts createState() => _Posts();
}

class _Posts extends State<Posts> {
  late Future<List<Map<String, dynamic>>> posts;

  @override
  void initState() {
    super.initState();
    posts = PostsApi.fetchPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      posts = PostsApi.fetchPosts();
    });
  }

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
                return Container(
                  height: 550,
                  child: Forum(
                    postTitle: postsData[index]['title'],
                    postContent: postsData[index]['content'],
                    username: postsData[index]['username'],
                    postedOn: postsData[index]['postedOn'],
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
