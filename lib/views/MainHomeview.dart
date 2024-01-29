// MainHome.dart

import 'package:flutter/material.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';

class MainHome extends StatelessWidget {
  const MainHome({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mentality",
          style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: CommonDrawer(),
    );
  }
}
