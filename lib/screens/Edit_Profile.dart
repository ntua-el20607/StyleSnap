import 'package:flutter/material.dart';
import 'package:stylesnap/screens/changephoto.dart';
import 'package:stylesnap/screens/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        _profilePictureUrl = userDoc['profilePictureUrl'];
        _usernameController.text = userDoc['username'] ?? '';
        _emailController.text = userDoc['email'] ?? '';
        _phoneController.text = userDoc['phoneNumber'] ?? '';
        _passwordController.text = userDoc['password'] ?? '';
      });
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future<void> _updateProfileData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'password': _passwordController.text,
      });

      // Optionally, you can reload the profile data after updating
      await _loadProfileData();
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: onLogoutPressed,
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileImage(),
                    const SizedBox(height: 10),
                    buildProfilePicture(),
                    const SizedBox(height: 20),
                    buildEditableInfoContainer("Username", _usernameController),
                    const SizedBox(height: 20),
                    buildEditableInfoContainer("Email", _emailController),
                    const SizedBox(height: 20),
                    buildEditableInfoContainer(
                        "Phone Number", _phoneController),
                    const SizedBox(height: 20),
                    buildEditableInfoContainer("Password", _passwordController),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          buildActionButtons(),
        ],
      ),
    );
  }

  void onLogoutPressed() {
    // Logic to handle user logout (e.g., clearing user data, etc.)

    // Navigate to the StartPage
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const start()),
      (Route<dynamic> route) => false,
    );
  }

  void onSavePressed() {
    _updateProfileData();
  }

  void onDeleteAccountPressed() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;

      // Get the user ID
      final userId = user!.uid;

      // Delete the user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Delete the user account
      await user.delete();

      // Navigate to the StartPage
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const start()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error deleting account: $e');
    }
  }

  Widget _buildProfileImage() {
    return ClipOval(
      child: SizedBox(
        width: 150,
        height: 150,
        child: _profilePictureUrl != null
            ? Image.network(
                _profilePictureUrl!,
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/images/profile_pic.png", // Default profile picture
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget buildProfilePicture() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePhotoScreen(
                  onPhotoTaken: (imagePath) {
                    Navigator.pop(context); // Close the ChangePhotoScreen
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: const Text(
            'Change Profile Picture',
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget buildEditableInfoContainer(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 30), // Added padding for spacing
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          fillColor: const Color(0xFFF4F4F4),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF4F4F51), width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 20), // Add horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Aligns items to start and end of the row
        children: [
          TextButton(
            onPressed: onSavePressed,
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF1D891B)), // Green text
            ),
          ),
          TextButton(
            onPressed: onDeleteAccountPressed,
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Color(0xFFC83030)), // Red text
            ),
          ),
        ],
      ),
    );
  }
}
