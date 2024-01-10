import 'package:flutter/material.dart';
import 'package:stylesnap/screens/start.dart';
import 'package:stylesnap/screens/login.dart';
import 'package:stylesnap/screens/sign_up.dart'; // Ensure this path is correct

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
      home: Login(), // Set the home to your Login widget
    );
  }
}
