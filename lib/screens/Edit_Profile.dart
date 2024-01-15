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

  // ... [Keep your existing methods here]

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery for responsive layout
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogoutPressed,
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Added to support scrolling
        child: Container(
          width: screenSize.width,
          padding: const EdgeInsets.all(20), // Uniform padding
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              buildProfilePicture(),
              const SizedBox(height: 20),
              buildEditableInfoContainer("Username", _usernameController),
              buildEditableInfoContainer("Email", _emailController),
              buildEditableInfoContainer("Phone Number", _phoneController),
              buildEditableInfoContainer("Password", _passwordController),
              const SizedBox(height: 20),
              buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfilePicture() {
    return Container(
      width: 80, // Adjusted size
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        shape: BoxShape.circle,
        border: Border.all(width: 0.50),
      ),
      child:
          const Icon(Icons.person, size: 48), // Placeholder for profile picture
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onSavePressed,
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF1D891B), // Green color
          ),
          child: const Text('Save'),
        ),
        ElevatedButton(
          onPressed: onDeleteAccountPressed,
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFC83030), // Red color
          ),
          child: const Text('Delete Account'),
        ),
      ],
    );
  }
}
