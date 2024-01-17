import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final String postId;

  const Comments({Key? key, required this.postId}) : super(key: key);

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
        .collection(
            'comments') // Assuming you have a subcollection for comments
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((data) {
      setState(() {
        comments = data.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  Future<void> _postComment() async {
    String commentText = _commentController.text;
    if (commentText.isEmpty) return;

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Fetch the user's profile picture URL and username
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    String profilePictureUrl =
        userDoc.data()?['profilePictureUrl'] ?? 'default_profile_picture_url';
    String username = userDoc.data()?['username'] ?? 'Anonymous';

    Map<String, dynamic> commentData = {
      'username': username,
      'commentText': commentText,
      'profilePictureUrl': profilePictureUrl,
      'timestamp': FieldValue.serverTimestamp(), // Add server timestamp
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
                  comment['username'],
                  comment['commentText'],
                  comment['profilePictureUrl'],
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
      String name, String comment, String profilePictureUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePictureUrl),
            radius: 35,
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
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                currentUserProfilePictureUrl), // Update with user's profile picture
            radius: 35,
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _postComment(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _postComment,
          ),
        ],
      ),
    );
  }
}
