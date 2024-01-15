import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/commets.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homeformals.dart';
import 'package:stylesnap/screens/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCasuals extends StatefulWidget {
  const HomeCasuals({super.key});

  @override
  _HomeCasualsState createState() => _HomeCasualsState();
}

class _HomeCasualsState extends State<HomeCasuals> {
  final List<int> _ratings = List.generate(100, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 89,
            child: Image.asset(
              "assets/images/logo_gramata.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'Casuals',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Positioned(
                right: 16.0,
                child: _buildArrowIcon(context),
              ),
            ],
          ),
          Expanded(
            child: _buildPostsList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Post.dart and wait for the result (photo URL)
          var photoURL = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => const Post()),
          );

          // Do something with the photo URL (e.g., save to Firestore, update UI)
          if (photoURL != null) {
            print('Received photo URL: $photoURL');

            // You can save the photo URL to Firestore or update the UI
            // ...

            // Example: Show a snackbar with the photo URL
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Received photo URL: $photoURL'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        tooltip: 'Take Picture',
        child: const Icon(Icons.camera),
      ),
    );
  }

  Stream<List<String>> getPostImages() {
    return FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['photo'].toString()).toList();
    });
  }

  Widget _buildPostsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getPostInfo(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Map<String, dynamic>>? postInfoList = snapshot.data;

        if (postInfoList == null || postInfoList.isEmpty) {
          return const Center(
            child: Text('No posts yet'),
          );
        }

        return ListView.builder(
          itemCount: postInfoList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> postInfo = postInfoList[index];
            String imageURL = postInfo['photoUrl'];
            return Column(
              children: [
                Image.network(imageURL, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      _buildStarRating(index),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: _buildCommentIcon(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Stream<List<Map<String, dynamic>>> getPostInfo() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('photos')
        .where('photoType', isEqualTo: 'Casual')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {'photoUrl': doc['photoUrl'].toString()})
          .toList();
    });
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Friends") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Friends()),
          );
        } else if (label == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Post()),
          );
        },
      ),
    );
  }

  Widget _buildStarRating(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (starIndex) {
        return IconButton(
          icon: Icon(
            _ratings[index] > starIndex ? Icons.star : Icons.star_border,
            color: _ratings[index] > starIndex ? Colors.amber : Colors.grey,
            size: 30.0,
          ),
          onPressed: () {
            setState(() {
              _ratings[index] = starIndex + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildCommentIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mode_comment, color: Colors.grey, size: 30.0),
      onPressed: () {
        _showCommentsScreen(context);
      },
    );
  }

  void _showCommentsScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return const Comments();
      },
    );
  }

  Widget _buildArrowIcon(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2),
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_forward, color: Colors.purple, size: 24),
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeFormals()),
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
