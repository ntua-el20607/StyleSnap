import 'package:flutter/material.dart';

class HomeCasuals extends StatelessWidget {
  const HomeCasuals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, // Ensure items stretch to fill the width
        children: [
          // Logo image with a SizedBox
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context)
                .size
                .width, // Adjust width to fit the screen
            height: 89, // Set a fixed height for the logo
            child: Image.asset(
              "assets/images/logo_gramata.png",
              fit:
                  BoxFit.contain, // Use BoxFit.contain to preserve aspect ratio
            ),
          ),
          const SizedBox(height: 5), // Space between logo and text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Text(
              'Casuals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Expanded scrollable column
          Expanded(
            child: ListView.builder(
              itemCount: 100, // Arbitrary large number for demo
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset("assets/images/casual.png", fit: BoxFit.cover),
                    const SizedBox(height: 15),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Text(label),
      ],
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Action for your button
      },
      backgroundColor: Colors.purple,
      child: const Icon(Icons.add), // Or any color you want
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavBarItem(context, Icons.home, "Home"),
          _buildNavBarItem(context, Icons.people, "Friends"),
          _buildCenterButton(context),
          _buildNavBarItem(context, Icons.search, "Search"),
          _buildNavBarItem(context, Icons.person, "Profile"),
        ],
      ),
    );
  }
}
