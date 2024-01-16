import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Edit_Profile.dart';
import 'package:stylesnap/screens/start.dart';
//import 'package:stylesnap/screens/addfriend.dart';
import 'firebase_options.dart';
//import 'package:stylesnap/screens/login.dart';
//import 'package:stylesnap/screens/sign_up.dart'; // Ensure this path is correct
//import 'package:stylesnap/screens/changephoto.dart';
//import 'package:stylesnap/screens/Edit_Profile.dart';
//import 'package:stylesnap/screens/scanQR.dart';
//import 'package:stylesnap/screens/Profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleSnap', // You can set the title of your application here
      theme: ThemeData(
        // You can define the global theme of your app here (optional)
        primarySwatch: Colors.blue,
      ),
      home: const start(), // Set the home to your Login widget
    );
  }
}
