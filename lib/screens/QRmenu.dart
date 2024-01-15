import 'package:flutter/material.dart';
// Import the qr_flutter package
import 'package:qr_flutter/qr_flutter.dart';

class QRMenuScreen extends StatelessWidget {
  const QRMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double qrSize = screenSize.width * 0.6;

    // Replace 'yourUniqueUserData' with the actual user data to generate the QR code
    final String qrData = 'yourUniqueUserData';

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.08,
          vertical: screenSize.height * 0.1,
        ),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildButtonBar(),
                SizedBox(height: screenSize.height * 0.1),
                // QR Code Widget
                QrImage(
                  data: qrData,
                  version: QrVersions.auto,
                  size: qrSize,
                  gapless: false,
                ),
              ],
            ),
            // Text Button for 'Back'
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Ribeye',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBar() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton('My QR', true),
          _buildButton('Scan', false),
        ],
      ),
    );
  }

  Widget _buildButton(String text, bool isLeft) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF9747FF),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(isLeft ? 22 : 0),
            right: Radius.circular(isLeft ? 0 : 22),
          ),
          border: isLeft ? null : const Border(left: BorderSide(width: 2)),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w800,
              letterSpacing: 0.10,
            ),
          ),
        ),
      ),
    );
  }
}
