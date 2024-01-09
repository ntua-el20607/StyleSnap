import 'package:flutter/material.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 355, height: 360),
              SizedBox(height: 70),
              SizedBox(
                width: 282,
                height: 66,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9747FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 17),
              SizedBox(
                width: 282,
                height: 66,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your sign-up logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9747FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Image.asset("assets/images/Hanger_icon.png",
                  width: 167, height: 167),
            ],
          ),
        ),
      ),
    );
  }
}
