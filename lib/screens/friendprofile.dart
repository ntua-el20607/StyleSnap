import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylesnap/screens/Post.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homecasuals.dart';

class friendprof extends StatelessWidget {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String username;

  const friendprof({
    super.key,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.username,
  });

  Future<String?> _getUserProfilePictureUrl(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return userDoc['profilePictureUrl'];
    } catch (e) {
      print('Error fetching user profile picture: $e');
      return null;
    }
  }

  Future<void> _removeFriend(BuildContext context) async {
    String currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
      'friends': FieldValue.arrayRemove([userId])
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend removed successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing friend: $error')),
      );
    });
  }

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : '';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogoGramata(),
            SizedBox(height: screenHeight * 0.03),
            _buildProfilePicture(username),
            SizedBox(height: screenHeight * 0.03),
            _buildActionButton(fullName),
            SizedBox(height: screenHeight * 0.05),
            _buildActionButton(email),
            SizedBox(height: screenHeight * 0.05),
            _buildActionButton(phoneNumber),
            SizedBox(height: screenHeight * 0.05),
            _buildRemoveFriendButton(context),
            const Spacer(),
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
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(String username) {
    return FutureBuilder<String?>(
      future: _getUserProfilePictureUrl(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return _defaultProfilePicture(username);
          } else {
            return _userProfilePicture(snapshot.data!);
          }
        } else {
          return _defaultProfilePicture(username);
        }
      },
    );
  }

  Widget _defaultProfilePicture(String username) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 142,
          height: 142.29,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            image: DecorationImage(
              image: AssetImage('assets/images/ruklas.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          username,
          style: const TextStyle(),
        ),
      ],
    );
  }

  Widget _userProfilePicture(String profilePictureUrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 142,
          height: 142.29,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            image: DecorationImage(
              image: NetworkImage(profilePictureUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          username,
          style: const TextStyle(),
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
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(),
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
        _removeFriend(context); // Implement the removal logic
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
