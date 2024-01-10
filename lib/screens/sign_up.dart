//import 'dart:js';
//import 'package:stylesnap/screens/start.dart';
//import 'package:stylesnap/screens/sign_up.dart'; // Correctly import your Login widget

import 'package:flutter/material.dart';
import 'package:stylesnap/screens/login.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Added to enable scrolling
        child: Center(
          // Center the column
          child: Column(
            children: [
              Container(
                width: 430,
                height: 932,
                padding: const EdgeInsets.only(
                    top: 75, left: 15, right: 15, bottom: 60),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeaderText(),
                    const SizedBox(height: 30),
                    _buildInputField('Full name', Icons.person),
                    const SizedBox(height: 30),
                    _buildInputField('Email', Icons.mail),
                    const SizedBox(height: 30),
                    _buildInputField('Phone Number', Icons.phone),
                    const SizedBox(height: 30),
                    _buildInputField('Username', Icons.person_outline),
                    const SizedBox(height: 30),
                    _buildPasswordInputField('Password'),
                    const SizedBox(height: 30),
                    _buildPasswordInputField('Confirm Password'),
                    const SizedBox(height: 30),
                    _buildSignUpButton(),
                    _buildLoginText(context),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: _buildBackOption(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData iconData) {
    return Container(
      width: 390,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFF7D56CB)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Icon(iconData, color: const Color(0xFF7D56CB)),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInputField(String label) {
    return Container(
      width: 390,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFF7D56CB)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Color(0xFF7D56CB)),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(), // Pushes the eye icon to the end of the row
          Icon(Icons.visibility, color: Colors.black.withOpacity(0.6)),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    return const SizedBox(
      width: 335,
      height: 85,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Create an account\n',
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.50),
            ),
            TextSpan(
              text: 'Style your life!',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 0.70),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: 282,
      height: 66,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Add your sign-up logic here
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF7D56CB), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // Rounded corners
          ),
        ),
        child: const Text('Sign Up'),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Already have an account? ',
        style: const TextStyle(color: Colors.black),
        children: [
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                // Navigate to the Login page when "Login" text is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Login()), // Replace with your login page widget
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color(0xFF471AA0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Navigate back to the previous page
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back, color: Colors.black),
          SizedBox(width: 5),
          Text(
            'Back',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
