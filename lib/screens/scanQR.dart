import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stylesnap/screens/QRmenu.dart';

class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(height: 100),
            _buildButtonBar(context),
            const SizedBox(height: 60),
            SizedBox(
              height: screenHeight * 0.5, // Adjust the height as needed
              child: _buildQRScanner(screenWidth, screenHeight),
            ),
            const Spacer(),
            // Wrap the QR scanner in Expanded
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    double buttonBarWidth = MediaQuery.of(context).size.width * 8 / 10;
    double buttonHeight = buttonBarWidth / 6;

    return Center(
      child: SizedBox(
        width: buttonBarWidth,
        height: buttonHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('My QR', true, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRMenuScreen()),
              );
            }),
            _buildButton('Scan', false, () {
              // Add logic for Scan button if needed
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, bool isLeft, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }

  Widget _buildQRScanner(double width, double height) {
    return Expanded(
      child: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: width * 0.8,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // Add your logic for when the QR code is scanned
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        'Back',
        style: TextStyle(
          color: Colors.black, // Text color changed to black
          fontSize: 22,
          fontFamily: 'Ribeye',
        ),
      ),
    );
  }
}
