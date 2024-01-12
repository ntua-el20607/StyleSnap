import 'package:flutter/material.dart';

class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 430,
        height: 932,
        padding: const EdgeInsets.only(
          top: 120,
          left: 38,
          right: 38,
          bottom: 105,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 309,
              height: 60,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 158,
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      clipBehavior: Clip.antiAlias,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF9747FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22),
                            bottomLeft: Radius.circular(22),
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'My QR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w800,
                            height: 0.06,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 151,
                    top: 0,
                    child: Container(
                      width: 158,
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9747FF),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                        border: Border(
                          left: BorderSide(width: 2),
                          top: BorderSide(),
                          right: BorderSide(),
                          bottom: BorderSide(),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Scan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w800,
                            height: 0.06,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 110),
            SizedBox(
              width: 289,
              height: 292,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 289,
                    height: 292,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage("https://via.placeholder.com/289x292"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                // Add your logic for the button press
                Navigator.pop(context); // Example: Navigate back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const SizedBox(
                width: 80,
                height: 40,
                child: Center(
                  child: Text(
                    'Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Ribeye',
                      fontWeight: FontWeight.w400,
                      height: 0.04,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
