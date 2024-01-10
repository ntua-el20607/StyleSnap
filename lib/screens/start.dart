import 'package:flutter/material.dart';
import 'package:stylesnap/screens/login.dart';
import 'package:stylesnap/screens/sign_up.dart';

class start extends StatelessWidget {
  const start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 355, height: 360),
              const SizedBox(height: 70),
              SizedBox(
                width: 282,
                height: 66,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Login()), // Navigate to Signup screen
                    ); // Add your login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9747FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              SizedBox(
                width: 282,
                height: 66,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Signup()), // Navigate to Signup screen
                    ); // Add your sign-up logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9747FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Image.asset("assets/images/Hanger_icon.png",
                  width: 167, height: 167),
            ],
          ),
        ),
      ),
    );
  }
}
