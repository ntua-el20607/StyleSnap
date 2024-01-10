import 'dart:js';
import 'package:stylesnap/screens/start.dart';
import 'package:stylesnap/screens/sign_up.dart'; // Correctly import your Login widget

import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
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
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeaderText(),
                    SizedBox(height: 30),
                    _buildInputField('Full name', Icons.person),
                    SizedBox(height: 30),
                    _buildInputField('Email', Icons.mail),
                    SizedBox(height: 30),
                    _buildInputField('Phone Number', Icons.phone),
                    SizedBox(height: 30),
                    _buildInputField('Username', Icons.person_outline),
                    SizedBox(height: 30),
                    _buildPasswordInputField('Password'),
                    SizedBox(height: 30),
                    _buildPasswordInputField('Confirm Password'),
                    SizedBox(height: 30),
                    _buildSignUpButton(),
                    _buildLoginText(),
                    _buildBackButton(context),
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
          side: BorderSide(width: 2, color: Color(0xFF7D56CB)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Icon(iconData, color: Color(0xFF7D56CB)),
          SizedBox(width: 10),
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
          side: BorderSide(width: 2, color: Color(0xFF7D56CB)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: Color(0xFF7D56CB)),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(), // Pushes the eye icon to the end of the row
          Icon(Icons.visibility, color: Colors.black.withOpacity(0.6)),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    return SizedBox(
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
        child: Text('Sign Up'),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF7D56CB), // Button color
          onPrimary: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // Rounded corners
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to login screen
      },
      child: Text.rich(
        TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: 'Login',
              style: TextStyle(
                  color: Color(0xFF471AA0), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => start()), // Navigate to Signup screen
          );
        },
        icon: Icon(Icons.arrow_back, size: 24),
        label: Text('Back'),
        style: TextButton.styleFrom(
          primary: Colors.black, // Text and icon color
        ),
      ),
    );
  }
}
