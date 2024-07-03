import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ArticlesView extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles Feed'),
      ),
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
                    child:TextButton(
                      onPressed: () async {
                        try {
                          final String urlString = article['url'];
                          print('URL: $urlString');
                          if (urlString != null && urlString.isNotEmpty) {
                            final Uri url = Uri.parse(urlString);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          } else {
                            throw 'Invalid URL: $urlString';
                          }
                        } catch (e) {
                          print('Error launching URL: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Could not launch the article URL.'),
                            ),
                          );
                        }
                      },
                      child: Text('Read more'),
                    )

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
