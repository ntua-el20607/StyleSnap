import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Post.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/nearme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Adjust spacing as needed
              _buildLogoGramata(context),
              const SizedBox(height: 35),
              _buildProfileImage(),
              const SizedBox(height: 10), // Space between image and text
              const Text(
                'Ruklas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Space between text and button
              _buildEditProfileButton(context),
              const SizedBox(height: 20),
              _buildDivider(),
              _buildTotalOutfitsSection(context),
              const SizedBox(height: 50),
              _buildTotalOutfitsCount(),
              const SizedBox(height: 50),
              _buildDivider(),
              _buildQRButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildLogoGramata(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double logoWidth = screenWidth * 1; // 90% of screen width

    return SizedBox(
      width: logoWidth,
      height:
          logoWidth / 4, // Adjust the height based on the logo's aspect ratio
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo_gramata.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return const CircleAvatar(
      radius: 71, // Adjust size as needed
      backgroundImage: AssetImage("assets/images/ruklas.png"),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.65; // 80% of the screen width

    return Container(
      width: buttonWidth,
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1), // Centers the button
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9747FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 15), // Adjust padding as needed
        ),
        child: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white), // Text color set to white
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0xFFD9D9D9));
  }

  Widget _buildTotalOutfitsSection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Text(
          'Total Outfits',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'Ribeye Marrow',
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          width: screenWidth * 0.5,
          height: 2,
          color: Colors.black, // Adjust color as needed
          margin: const EdgeInsets.only(top: 8),
        ),
      ],
    );
  }

  Widget _buildTotalOutfitsCount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16), // Adjust padding as needed
        child: const Text(
          'Total Outfits:       70',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildQRButton() {
    return IconButton(
      iconSize: 40, // Increase the icon size
      icon: const Icon(Icons.qr_code),
      onPressed: () {
        // Handle QR button press
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeCasuals()),
              );
            },
            child: _buildNavBarItem(context, Icons.home, "Home"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Friends()),
              );
            },
            child: _buildNavBarItem(context, Icons.people, "Friends"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Post()),
              );
            },
            child: _buildCenterButton(context),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Nearme()),
              );
            },
            child: _buildNavBarItem(context, Icons.search, "Search"),
          ),
          GestureDetector(
            onTap: () {
              // Current screen, no need to navigate
            },
            child: _buildNavBarItem(context, Icons.person, "Profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            color: Colors.purple), // Replace with your icon assets and colors
        Text(label,
            style: const TextStyle(
                color: Colors.purple)), // Adjust the styling as needed
      ],
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Container(
      width: 57, // Diameter of the circle
      height: 57, // Diameter of the circle
      decoration: const BoxDecoration(
        color: Colors.purple, // Replace with the exact purple color you need
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add,
          color: Colors.white), // Replace with your custom cross icon
    );
  }
}
