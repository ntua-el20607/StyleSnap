import 'package:flutter/material.dart';

class friendprof extends StatelessWidget {
  const friendprof({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLogoGramata(),
            const SizedBox(height: 27),
            _buildProfilePicture(),
            const SizedBox(height: 27),
            _buildActionButton("GiorgakisThePresident"),
            const SizedBox(height: 50),
            _buildActionButton("georgebush@gmail.com"),
            const SizedBox(height: 50),
            _buildActionButton("+13727267482"),
            const SizedBox(height: 50),
            _buildRemoveFriendButton(),
            const SizedBox(height: 50),
            _buildBottomNavigationBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoGramata() {
    return const SizedBox(
      width: 366,
      height: 89,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo_gramata.png'),
            fit: BoxFit
                .contain, // This will fill the entire box with the image, possibly distorting the aspect ratio
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 142,
          height: 142.29,
          decoration: const ShapeDecoration(
            shape: CircleBorder(), // Circle shape for the profile picture
            image: DecorationImage(
              image: AssetImage('assets/images/ruklas.png'),
              fit: BoxFit.cover, // Ensures the image covers the container
            ),
          ),
        ),
        const SizedBox(height: 10), // Space between the image and the text
        const Text(
          'George Bush',
          style: TextStyle(
              // Define this style as per your design requirements
              ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text) {
    return SizedBox(
      width: 388,
      height: 74,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(width: 2, color: Color(0xFF9747FF)),
          ),
          // Other properties...
        ),
        child: Center(
          // Center the text inside the container
          child: Text(
            text,
            style: const TextStyle(
                // Define this style as a constant if reused
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .scaffoldBackgroundColor, // Change this to the color of your page's background
      width: 429, // This will take the full width of the screen
      height: 90, // The height you want
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavBarItem(context, Icons.home, "Home"),
          _buildNavBarItem(context, Icons.people, "Friends"),
          _buildCenterButton(context), // Special button in the middle
          _buildNavBarItem(context, Icons.search, "Search"),
          _buildNavBarItem(context, Icons.person, "Profile"),
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
            color:
                const Color(0xFF8A56AC)), // Replace with your icon assets and colors
        Text(label,
            style: const TextStyle(
                color: Color(0xFF8A56AC))), // Adjust the styling as needed
      ],
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Container(
      width: 68, // Diameter of the circle
      height: 68, // Diameter of the circle
      decoration: const BoxDecoration(
        color:
            Color(0xFF8A56AC), // Replace with the exact purple color you need
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add,
          color: Colors.white), // Replace with your custom cross icon
    );
  }

  Widget _buildRemoveFriendButton() {
    return TextButton(
      onPressed: () {
        // Implement the removal logic
      },
      child: const Text(
        'Remove Friend',
        style: TextStyle(
          color: Color(0xFFC83030),
          fontSize: 25,
          // Define this style as a constant if reused
        ),
      ),
    );
  }
}
