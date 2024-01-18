import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/commets.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homeformals.dart';
import 'package:stylesnap/screens/nearme.dart';
import 'package:stylesnap/screens/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCasuals extends StatefulWidget {
  const HomeCasuals({super.key});

  @override
  _HomeCasualsState createState() => _HomeCasualsState();
}

class _HomeCasualsState extends State<HomeCasuals> {
  Map<String, int> postRatings = {};
  final List<int> _ratings = List.generate(100, (index) => 0);

  @override
  void initState() {
    super.initState();
    fetchInitialRatings(); // Call the method here
  }

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
    );
  }

  Stream<List<String>> getPostImages() {
    return FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['photos'].toString()).toList();
    });
  }

  Widget _buildPostsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: getPostInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            String postId = doc.id; // Firestore document ID as postId
            Map<String, dynamic> postInfo = doc.data() as Map<String, dynamic>;
            String? imageUrl = postInfo['imageUrl'];

            return Column(
              children: [
                Image.network(
                  imageUrl ?? 'default_image_url_here',
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('Failed to load image');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      _buildStarRating(postId),
                      const Spacer(),
                      _buildCommentIcon(context, postId),
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

  Stream<QuerySnapshot> getPostInfo() {
    return _fetchFriendsList().asStream().asyncExpand((friends) {
      if (friends.isEmpty) {
        return const Stream.empty();
      }
      return FirebaseFirestore.instance
          .collection('posts')
          .where('photoType', isEqualTo: 'Casual')
          .where('userId', whereIn: friends)
          .snapshots();
    });
  }

  Future<List<dynamic>> _fetchFriendsList() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    List<dynamic> friends = userDoc.data()?['friends'] ?? [];
    friends.add(currentUser.uid); // Include the user's ID
    return friends;
  }

  // Listen to the posts collection

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

  Widget _buildCommentIcon(BuildContext context, String postId) {
    return IconButton(
      icon: const Icon(Icons.mode_comment, color: Colors.grey, size: 30.0),
      onPressed: () {
        _showCommentsScreen(context, postId);
      },
    );
  }

  void _showCommentsScreen(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Comments(postId: postId);
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

  Widget _buildStarRating(String postId) {
    int userRating = postRatings[postId] ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            userRating > index ? Icons.star : Icons.star_border,
            color: userRating > index ? Colors.amber : Colors.grey,
          ),
          onPressed: () async {
            await updateUserRatingForPost(postId, index + 1);
            setState(() {
              postRatings[postId] = index + 1;
            });
          },
        );
      }),
    );
  }

  Future<int> getUserRatingForPost(String postId) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return 0;

    try {
      var ratingDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('ratings')
          .doc(currentUser.uid)
          .get();

      if (ratingDoc.exists) {
        var data = ratingDoc.data();
        return data?['rating'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching user rating: $e');
      return 0;
    }
  }

  Future<void> updateUserRatingForPost(String postId, int rating) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var ratingRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('ratings')
        .doc(currentUser.uid);

    // Check if the rating document exists
    var doc = await ratingRef.get();
    if (!doc.exists) {
      // Create the document with the initial rating
      await ratingRef.set({
        'rating': rating,
      });
    } else {
      // Update the existing rating
      await ratingRef.update({
        'rating': rating,
      });
    }
  }

  void fetchInitialRatings() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var snapshot = await FirebaseFirestore.instance.collection('posts').get();

    var initialRatings = <String, int>{};
    for (var doc in snapshot.docs) {
      var ratingDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(doc.id)
          .collection('ratings')
          .doc(currentUser.uid)
          .get();

      initialRatings[doc.id] = ratingDoc.data()?['rating'] ?? 0;
    }

    if (mounted) {
      setState(() {
        postRatings = initialRatings;
      });
    }
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
