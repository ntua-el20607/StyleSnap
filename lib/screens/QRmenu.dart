import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRMenuScreen extends StatelessWidget {
  const QRMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getUserData(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final String qrData = snapshot.data!['userData'];

            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButtonBar(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _generateQRCode(context, qrData),
                    child: const Text('Generate QR Code'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ],
              ),
            );
          }
        },
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

  Future<DocumentSnapshot> _getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      String userId = auth.currentUser!.uid;
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    } else {
      throw Exception('User not signed in');
    }
  }

  Future<void> _generateQRCode(BuildContext context, String qrData) async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // background color
        'Cancel', // cancel button text
        true, // show flash icon (Android only)
        ScanMode.QR, // scan mode (QR by default)
      );

      if (barcodeScanResult == '-1') {
        // User pressed the 'Cancel' button
        return;
      }

      // Handle the scanned result, you can use it as needed
      print('Scanned Result: $barcodeScanResult');
    } catch (e) {
      print('Error: $e');
    }
  }
}
