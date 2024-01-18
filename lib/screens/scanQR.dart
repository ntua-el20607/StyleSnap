import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stylesnap/screens/QRmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              child: _buildQRScanner(context, screenWidth, screenHeight),
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

  Widget _buildQRScanner(BuildContext context, double width, double height) {
    return Expanded(
      child: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: (controller) {
          _onQRViewCreated(
              controller, context); // Pass both controller and context
        },
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

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    controller.scannedDataStream.listen((scanData) async {
      // Extract the UserID from the scanned QR code data
      String scannedUserId = scanData.code ?? '';

      // Check if the scanned UserID exists in your Firestore database
      bool userExists = await checkIfUserExists(scannedUserId);

      if (userExists) {
        // Add the scanned user to your friend list
        bool addedToFriends = await addToFriendList(scannedUserId);

        if (addedToFriends) {
          // Display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User added to your friend list.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Display an error message if adding to friends fails
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add user to friend list.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Display a message if the scanned UserID doesn't exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  Future<bool> checkIfUserExists(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  Future<bool> addToFriendList(String userId) async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return false;

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      List<dynamic> friends = userDoc.data()?['friends'] ?? [];
      if (!friends.contains(userId)) {
        friends.add(userId);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'friends': friends});
      }

      return true;
    } catch (e) {
      print('Error adding user to friend list: $e');
      return false;
    }
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
