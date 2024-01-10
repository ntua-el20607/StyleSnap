import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitleText('Hi, Welcome Back! 👋'),
              const SizedBox(height: 40),
              _buildInputField('Email'),
              const SizedBox(height: 40),
              _buildInputField('Password'),
              const SizedBox(height: 40),
              _buildLoginButton(),
              const SizedBox(height: 40),
              _buildSignUpText(context),
              const SizedBox(height: 40),
              _buildBackOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.none, // Remove underline
      ),
    );
  }

  Widget _buildInputField(String placeholder) {
    return Container(
      width: 390,
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color(0xFF7D56CB)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        placeholder,
        style: TextStyle(
          color: Colors.black.withOpacity(0.3),
          fontSize: 15,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none, // Remove underline
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: 282,
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: Color(0xFF9747FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Center(
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
          TextSpan(
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
                // Insert your navigation or action here
                print('Sign Up Clicked');
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Color(0xFF471AA0),
                  fontSize: 15.50,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  decoration:
                      TextDecoration.none, // Ensures text is not underlined
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackOption() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Back',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none, // Remove underline
          ),
        ),
      ],
    );
  }
}
