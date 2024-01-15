import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRMenuScreen extends StatelessWidget {
  const QRMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data available'));
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final String qrData = userData['uid'] ??
                'Default Data'; // Replace 'uid' with the appropriate field

            return Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // This is where QrImage is used
                  if (qrData.isNotEmpty)
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0, // Adjust size as needed
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
      return FirebaseFirestore.instance.collection('users').doc(userId).get();
    } else {
      throw Exception('User not signed in');
    }
  }

  QrImageView _generateQRCodeWidget(String qrData) {
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 200.0, // Adjust size as needed
      gapless: false,
    );
  }
}
