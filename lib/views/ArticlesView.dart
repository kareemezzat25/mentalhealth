import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart'; // Import your CommonDrawer widget

class ArticlesView extends StatefulWidget {
  final String userId;

  ArticlesView({required this.userId}); // Add userId parameter

  @override
  _ArticlesViewState createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final response = await http.get(
        Uri.parse('https://nexus-api-h3ik.onrender.com/api/articles'),
        headers: {'Content-Language': 'en'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        setState(() {
          articles = responseBody['articles'];
        });
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _launchURL(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);

      if (await canLaunch(urlString)) {
        if (Theme.of(context).platform == TargetPlatform.android) {
          // Android-specific: try to launch Chrome
          final String chromeUrl = 'googlechrome://navigate?url=$urlString';
          if (await canLaunch(chromeUrl)) {
            await launch(chromeUrl);
            return;
          }
        }

        await launch(urlString);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch the article URL.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      drawer: CommonDrawer(userId: widget.userId), // Add the drawer here
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article['urlToImage'] != null)
                    Image.network(article['urlToImage']),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article['description'] ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      
                      onPressed: () {
                        final url = article['url'];
                        if (url != null) {
                          launchUrlString(article['url']);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Article URL is not available.'),
                            ),
                          );
                        }
                      },
                      child: Text('Read more',style: TextStyle(color:Color(0xff01579B)),),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
