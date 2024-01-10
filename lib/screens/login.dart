import 'package:flutter/material.dart';
import 'package:stylesnap/screens/sign_up.dart';
//import 'package:stylesnap/screens/start.dart';
//import 'package:stylesnap/screens/sign_up.dart';
//import 'dart:js';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitleText('Hi, Welcome Back!'),
              const SizedBox(height: 40),
              _buildInputField('Email', Icons.email),
              const SizedBox(height: 40),
              _buildInputField('Password', Icons.lock),
              const SizedBox(height: 40),
              _buildLoginButton(),
              const SizedBox(height: 40),
              _buildSignUpText(context),
              const SizedBox(height: 40),
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
      ),
    );
  }

  Widget _buildTitleText(String text) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: 'Hi, Welcome Back! ',
            style: TextStyle(color: Colors.black),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 2.0), // Adjust padding as needed
              child: Icon(
                Icons.waving_hand, // Replace with the icon you want to use
                color: Color.fromARGB(
                    255, 248, 171, 4), // Custom color, adjust as needed
                size: 24, // Adjust size to match your text
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String placeholder, IconData iconData) {
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
          Icon(
            iconData,
            color: const Color(0xFF9747FF), // Same color as the login button
          ),
          const SizedBox(width: 10),
          Text(
            placeholder,
            style: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: 282,
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: const Color(0xFF9747FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: const Center(
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w800,
            letterSpacing: 0.10,
            decoration: TextDecoration.none, // Remove underline
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Don’t have an account? ',
            style: TextStyle(
              color: Color(0xFF471AA0),
              fontSize: 15.50,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                // Navigate to the Sign Up page when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Color(0xFF471AA0),
                  fontSize: 15.50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
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
