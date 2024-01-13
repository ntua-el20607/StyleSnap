import 'package:flutter/material.dart';
import 'package:stylesnap/screens/login.dart';
import 'package:stylesnap/screens/sign_up.dart';

class start extends StatelessWidget {
  const start({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Image.asset(
                "assets/images/Logo.png",
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
              ),
            ),
            const SizedBox(height: 70),
            SizedBox(
              width: 282,
              height: 66,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
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
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
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
            Image.asset(
              "assets/images/Hanger_icon.png",
              width: screenWidth * 0.5,
              height: screenWidth * 0.5,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('Failed to load image');
              },
            ),
          ],
        ),
      ),
    );
  }
}
