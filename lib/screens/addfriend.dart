import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylesnap/screens/Post.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homecasuals.dart';

class addfriend extends StatelessWidget {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String username;

  const addfriend({
    super.key,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.username,
  });

  Future<void> _addfriend(BuildContext context) async {
    String currentUserId = getCurrentUserId(); // Get the current user's ID
    if (currentUserId.isEmpty) {
      // Handle the case where there is no logged-in user
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
      'friends': FieldValue.arrayUnion([userId])
    }).then((_) {
      // Show a confirmation message or update the UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend added successfully!')),
      );
    }).catchError((error) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding friend: $error')),
      );
    });
  }

  Future<String> _getProfilePictureUrl(String userId) async {
    try {
      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Get the profilePictureUrl field from the document
      return userDoc['profilePictureUrl'] ?? '';
    } catch (e) {
      print('Error fetching profile picture URL: $e');
      return ''; // Return an empty string or a default URL in case of an error
    }
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : '';
  }

  @override
  Widget build(BuildContext context) {
    // We use MediaQuery to get the height and subtract the status bar height if necessary.
    double screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        // Added SafeArea for proper spacing at the top
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogoGramata(),
            SizedBox(
                height: screenHeight * 0.03), // 3% of screen height for spacing
            _buildProfilePicture(username, userId),
            SizedBox(
                height: screenHeight * 0.03), // 3% of screen height for spacing
            _buildActionButton(fullName),
            SizedBox(
                height: screenHeight * 0.05), // 5% of screen height for spacing
            _buildActionButton(email),
            SizedBox(
                height: screenHeight * 0.05), // 5% of screen height for spacing
            _buildActionButton(phoneNumber),
            SizedBox(
                height: screenHeight * 0.05), // 5% of screen height for spacing
            _buildRemoveFriendButton(context),
            const Spacer(), // Pushes the navigation bar to the bottom
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

  Widget _buildProfilePicture(String username, String userId) {
    return FutureBuilder(
      future: _getProfilePictureUrl(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the data, show a loading indicator or placeholder
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs, handle it accordingly
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // If data is available, display the profile picture
          String profilePictureUrl = snapshot.data.toString();
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 142,
                height: 142.29,
                decoration: ShapeDecoration(
                  shape: const CircleBorder(), // Circle shape for the profile picture
                  image: DecorationImage(
                    image: NetworkImage(profilePictureUrl),
                    fit: BoxFit.cover, // Ensures the image covers the container
                  ),
                ),
              ),
              const SizedBox(
                  height: 10), // Space between the image and the text
              Text(
                username,
                style: const TextStyle(
                    // Define this style as per your design requirements
                    ),
              ),
            ],
          );
        } else {
          // Handle the case where no data is available
          return const Text('No data available');
        }
      },
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
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavBarItem(
            context,
            Icons.home,
            "Home",
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeCasuals()),
              );
            },
          ),
          _buildNavBarItem(
            context,
            Icons.people,
            "Friends",
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Friends()),
              );
            },
          ),
          _buildCenterButton(context),
          _buildNavBarItem(
            context,
            Icons.search,
            "Search",
            () {
              // Perform the desired action for the Search button
            },
          ),
          _buildNavBarItem(
            context,
            Icons.person,
            "Profile",
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.purple),
          Text(
            label,
            style: const TextStyle(color: Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Container(
      width: 57,
      height: 57,
      decoration: const BoxDecoration(
        color: Colors.purple,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navigate to the Post screen when the + button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Post()),
          );
        },
      ),
    );
  }

  Widget _buildRemoveFriendButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _addfriend(context); // Implement the removal logic
      },
      child: const Text(
        'Add Friend',
        style: TextStyle(
          color: Color.fromARGB(255, 20, 148, 24),
          fontSize: 25,
          // Define this style as a constant if reused
        ),
      ),
    );
  }
}
