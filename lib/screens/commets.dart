import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/addfriend.dart';
import 'package:stylesnap/screens/friendprofile.dart';

class Comments extends StatefulWidget {
  final String postId;

  const Comments({super.key, required this.postId});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List<Map<String, dynamic>> comments = [];
  final TextEditingController _commentController = TextEditingController();
  String currentUserProfilePictureUrl = 'default_profile_picture_url';
  @override
  void initState() {
    super.initState();
    _fetchCurrentUserProfile();
    _fetchComments();
  }

  Future<void> _fetchCurrentUserProfile() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    setState(() {
      currentUserProfilePictureUrl =
          userDoc.data()?['profilePictureUrl'] ?? 'default_profile_picture_url';
    });
  }

  Future<void> _fetchComments() async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((data) {
      if (mounted) {
        setState(() {
          comments = data.docs.map((doc) => doc.data()).toList();
        });
      }
    });
  }

  Future<void> _postComment() async {
    String commentText = _commentController.text;
    if (commentText.isEmpty) return;

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (!userDoc.exists) {
      print("User document does not exist");
      return;
    }

    Map<String, dynamic> commentData = {
      'userId': currentUser.uid,
      'username': userDoc.data()?['username'] ?? 'Anonymous',
      'commentText': commentText,
      'profilePictureUrl':
          userDoc.data()?['profilePictureUrl'] ?? 'default_profile_picture_url',
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add(commentData);

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCommentHeader(context),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var comment = comments[index];
                return _buildCommentSection(
                  comment['username'] ??
                      'Unknown', // Default to 'Unknown' if null
                  comment['commentText'] ??
                      '', // Default to empty string if null
                  comment['profilePictureUrl'] ??
                      'default_image_url', // Default image URL if null
                  comment['userId'] ?? '', // Default to empty string if null
                );
              },
            ),
          ),
          _buildCommentInputField(),
        ],
      ),
    );
  }

  Widget _buildCommentHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6,
      decoration: const BoxDecoration(
        color: Colors.white, // Include color here
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(
      String name, String comment, String profilePictureUrl, String userId) {
    // Determine if the comment belongs to the current user
    bool isCurrentUser = FirebaseAuth.instance.currentUser?.uid == userId;

    return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while fetching
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return Text('Error fetching user details'); // Error handling
          }
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          String profilePictureUrl =
              userData['profilePictureUrl'] ?? 'default_profile_picture_url';

          ImageProvider imageProvider;
          if (profilePictureUrl != "default_profile_picture_url") {
            imageProvider = NetworkImage(profilePictureUrl);
          } else {
            imageProvider = const AssetImage('assets/images/profile_pic.png');
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (isCurrentUser) {
                      // Navigate to the logged-in user's profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    } else {
                      print("Fetching details for userId: $userId");
                      var userDetails = await getUserDetails(userId);
                      print("User details fetched: $userDetails");

                      if (userDetails.isNotEmpty) {
                        bool friendStatus = await isFriend(userId);
                        if (friendStatus) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => friendprof(
                                userId: userId,
                                fullName: userDetails['fullName'],
                                email: userDetails['email'],
                                phoneNumber: userDetails['phoneNumber'],
                                username: userDetails['username'],
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addfriend(
                                userId: userId,
                                fullName: userDetails['fullName'],
                                email: userDetails['email'],
                                phoneNumber: userDetails['phoneNumber'],
                                username: userDetails['username'],
                              ),
                            ),
                          );
                        }
                      } else {
                        print("No user details found for userId: $userId");
                      }
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 35,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(comment),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    // Check if userId is not empty
    if (userId.isEmpty) {
      print('Error: UserId is empty');
      return {};
    }

    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return {
          'fullName': userDoc.data()?['fullName'] ?? '',
          'email': userDoc.data()?['email'] ?? '',
          'phoneNumber': userDoc.data()?['phoneNumber'] ?? '',
          'username': userDoc.data()?['username'] ?? '',
        };
      } else {
        print('User document does not exist');
        return {};
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data();
      }
      return null;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<bool> isFriend(String userId) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    List<dynamic> friends = userDoc.data()?['friends'] ?? [];
    return friends.contains(userId);
  }

  Future<String?> getUserIdByUsername(String username) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Return the userId
    }
    return null;
  }

  Widget _buildCommentInputField() {
    var imageProvider = (currentUserProfilePictureUrl.isNotEmpty &&
            currentUserProfilePictureUrl != 'default_profile_picture_url')
        ? NetworkImage(currentUserProfilePictureUrl) as ImageProvider
        : const AssetImage('assets/images/profile_pic.png');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                imageProvider, // Update with user's profile picture
            radius: 35,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _postComment(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _postComment,
          ),
        ],
      ),
    );
  }
}
