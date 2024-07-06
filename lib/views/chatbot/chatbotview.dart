import 'dart:convert';

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
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script>
              window.embeddedChatbotConfig = {
                chatbotId: "L5-3qOwyut8Ry3sQ9uRcp",
                domain: "www.chatbase.co"
              };
              window.addEventListener('load', function() {
                const chatbotButton = document.querySelector('button[chatbotId="L5-3qOwyut8Ry3sQ9uRcp"]');
                if (chatbotButton) {
                  chatbotButton.click();
                }
              });
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
        ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
