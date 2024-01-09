import 'package:flutter/material.dart';
import 'package:stylesnap/screens/login.dart'; // Ensure this path is correct

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleSnap', // You can set the title of your application here
      theme: ThemeData(
        // You can define the global theme of your app here (optional)
        primarySwatch: Colors.blue,
      ),
      home: login(), // Set the home to your Login widget
    );
  }
}
