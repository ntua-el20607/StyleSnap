import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Post.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/nearme.dart';
import 'package:stylesnap/screens/profile.dart'; // Import your Profile screen here
import 'package:stylesnap/screens/changephoto.dart'; // Import your ChangePhoto screen here

class ScrollableImageRow extends StatelessWidget {
  const ScrollableImageRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6, // Number of items in the row
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/ruklas.png',
                ), // Replace with dynamic image path
                const Text(
                  'ruklas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ), // Replace with dynamic text
              ],
            ),
          );
        },
      ),
    );
  }
}

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40), // Extra space at the top
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'FRIENDS',
                  style: TextStyle(
                    color: Color(0xFF471AA0),
                    fontSize: 30,
                    fontFamily: 'Ribeye',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 200, // Adjust height as needed
              child: ScrollableImageRow(),
            ),
            buildTopFriendsText(context),
            buildTextWithImage(context, 'Top Casual Outfits:      89'),
            buildTextWithImage(context, 'Top Formal Outfits:      77'),
            buildTextWithImage(context, 'Top Average Score:   4.6/5'),
            buildTextWithImage(context, 'Top Streak:                 226'),
            // Add other widgets here if needed
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget buildBackgroundContainer() {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget buildTopFriendsText(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Top Friends',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Ribeye Marrow',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 4, // Space between text and line
        ),
        Container(
          width: MediaQuery.of(context).size.width *
              0.6, // Line width = 1/3 longer than text
          height: 2,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget buildTextWithImage(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          15, 8, 15, 8), // Add margin on the left and right
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            // Using Expanded to fill the available space and align the image to the right
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20, // Regular size 20
              ),
            ),
          ),
          const SizedBox(width: 10), // Adjust the space between text and image
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/ruklas.png'), // Image path
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Handle navigation based on the selected icon
        if (label == "Home") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeCasuals()),
          );
        } else if (label == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (label == "Search") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Nearme()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.purple), // Set the icon color to purple
          Text(
            label,
            style: const TextStyle(
              color: Colors.purple,
            ), // Set the text color to purple
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Container(
      width: 57, // Diameter of the circle
      height: 57, // Diameter of the circle
      decoration: const BoxDecoration(
        color: Colors.purple, // Background color of the button
        shape: BoxShape.circle, // Circular shape
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Post()), // Navigate to ChangePhoto screen
          );
        },
      ),
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
