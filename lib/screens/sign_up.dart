import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/screens/login.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeaderText(context),
                const SizedBox(height: 30),
                _buildInputField(
                    'Full name', Icons.person, _fullNameController),
                const SizedBox(height: 30),
                _buildInputField('Email', Icons.mail, _emailController),
                const SizedBox(height: 30),
                _buildInputField(
                    'Phone Number', Icons.phone, _phoneNumberController),
                const SizedBox(height: 30),
                _buildInputField(
                    'Username', Icons.person_outline, _usernameController),
                const SizedBox(height: 30),
                _buildPasswordInputField('Password', _passwordController),
                const SizedBox(height: 30),
                _buildPasswordInputField(
                    'Confirm Password', _confirmPasswordController),
                const SizedBox(height: 30),
                _buildSignUpButton(context),
                _buildLoginText(context),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 1),
                    child: _buildBackOption(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, IconData iconData, TextEditingController controller) {
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
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInputField(
      String label, TextEditingController controller) {
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
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width *
              0.05), // 5% padding on each side
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Create an account\n',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50,
              ),
            ),
            TextSpan(
              text: 'Style your life!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w100,
                letterSpacing: 0.70,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: 282,
      height: 66,
      child: ElevatedButton(
        onPressed: () {
          if (_areAllFieldsOkay()) {
            _signUp(context); // Pass the context to the _signUp function
          } else {
            // Show an error message or take appropriate action
            print("Not all fields are okay. Please check your input.");
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF9747FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 18),
        ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
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
        Navigator.pop(context);
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

  Future<void> _signUp(BuildContext context) async {
    try {
      if (_areAllFieldsOkay()) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _phoneNumberController.text.trim(),
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
          'friends': {}, // Empty friends list initially
          // Add other fields as needed
        });

        // Navigate to the login page after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      // Handle signup errors...
      print("Error during signup: $e");
    }
  }

  bool _areAllFieldsOkay() {
    return _isFullNameValid(_fullNameController.text.trim()) &&
        _isEmailValid(_emailController.text.trim()) &&
        _isPhoneNumberValid(_phoneNumberController.text.trim()) &&
        _isUsernameValid(_usernameController.text.trim()) &&
        _isPasswordValid(_passwordController.text.trim()) &&
        _isConfirmPasswordValid(
          _passwordController.text.trim(),
          _confirmPasswordController.text.trim(),
        );
  }

  bool _isFullNameValid(String fullName) {
    return fullName.isNotEmpty &&
        fullName.length >= 2 &&
        fullName.length <= 20 &&
        RegExp(r'^[a-zA-Z ]+$').hasMatch(fullName);
  }

  bool _isEmailValid(String email) {
    return email.isNotEmpty &&
        email.length >= 5 &&
        email.length <= 25 &&
        RegExp(r'^[a-zA-Z0-9]+@gmail\.com$').hasMatch(email);
  }

  bool _isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.isNotEmpty &&
        phoneNumber.length == 10 &&
        phoneNumber.startsWith('69') &&
        int.tryParse(phoneNumber.substring(2)) != null;
  }

  bool _isUsernameValid(String username) {
    return username.isNotEmpty && username.length >= 2 && username.length <= 20;
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty && password.length >= 8;
  }

  bool _isConfirmPasswordValid(String password, String confirmPassword) {
    return confirmPassword.isNotEmpty && confirmPassword == password;
  }
}
