import 'package:flutter/material.dart';

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

  void onLogoutPressed() {
    // Add your logout logic here
  }

  void onSavePressed() {
    // Add your save logic here
    String updatedUsername = _usernameController.text;
    String updatedEmail = _emailController.text;
    String updatedPhone = _phoneController.text;
    String updatedPassword = _passwordController.text;

    // Perform actions with updated user information
  }

  void onDeleteAccountPressed() {
    // Add your delete account logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogoutPressed,
          ),
        ],
      ),
      body: Container(
        width: 430,
        height: 932,
        padding: const EdgeInsets.only(
          top: 120,
          left: 55,
          right: 55,
          bottom: 75,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        shape: BoxShape.circle,
                        border: Border.all(width: 0.50),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24.01,
                            height: 24.01,
                            child: Stack(
                              children: [
                                // Your stack content
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150),
            buildEditableInfoContainer("Username", _usernameController),
            const SizedBox(height: 25),
            buildEditableInfoContainer("Email", _emailController),
            const SizedBox(height: 25),
            buildEditableInfoContainer("Phone Number", _phoneController),
            const SizedBox(height: 25),
            buildEditableInfoContainer("Password", _passwordController),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onSavePressed,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Color(0xFF1D891B), // Green color
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onDeleteAccountPressed,
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Color(0xFFC83030), // Red color
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableInfoContainer(
      String title, TextEditingController controller) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(color: Color(0xFFF4F4F4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              border: Border.all(
                color: const Color(0xFF4F4F51),
                width: 1.50,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF4F4F51),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                    letterSpacing: 0.40,
                  ),
                ),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
