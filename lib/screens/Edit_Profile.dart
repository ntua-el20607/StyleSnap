import 'package:flutter/material.dart';
import 'package:stylesnap/screens/changephoto.dart';
import 'package:stylesnap/screens/start.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'John22');
  final TextEditingController _emailController =
      TextEditingController(text: 'john22@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+307777777777');
  final TextEditingController _passwordController =
      TextEditingController(text: 'john22john');

  // ... [Keep your existing methods here]

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
                    buildProfilePicture(),
                    const SizedBox(height: 30),
                    buildEditableInfoContainer("Username", _usernameController),
                    const SizedBox(height: 30),
                    buildEditableInfoContainer("Email", _emailController),
                    const SizedBox(height: 30),
                    buildEditableInfoContainer(
                        "Phone Number", _phoneController),
                    const SizedBox(height: 30),
                    buildEditableInfoContainer("Password", _passwordController),
                    const SizedBox(height: 30),
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
    // Placeholder for future implementation
    print("Save button pressed"); // Optional: for debugging
  }

  void onDeleteAccountPressed() {
    // Placeholder for future implementation
    print("Delete account button pressed"); // Optional: for debugging
  }

  Widget buildProfilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.50),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/ruklas.png'), // Your image path
            ),
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChangePhotoScreen()),
              );
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_camera,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEditableInfoContainer(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 10), // Added padding for spacing
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
