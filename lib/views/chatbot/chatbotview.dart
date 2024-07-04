// chatbot_page.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString('''
          <!DOCTYPE html>
          <html>
          <head>
            <script>
              window.embeddedChatbotConfig = {
                chatbotId: "L5-3qOwyut8Ry3sQ9uRcp",
                domain: "www.chatbase.co"
              }
            </script>
            <script
              src="https://www.chatbase.co/embed.min.js"
              chatbotId="L5-3qOwyut8Ry3sQ9uRcp"
              domain="www.chatbase.co"
              defer>
            </script>
          </head>
          <body>
          </body>
          </html>
        ''', mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
