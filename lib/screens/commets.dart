import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  const Comments({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCommentHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    12,
                    (index) => _buildCommentSection(
                        "User $index", "Comment text $index", 'ruklas.png')),
              ),
            ),
          ),
          _buildCommentInputField('ruklas.png'),
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

  Widget _buildCommentSection(String name, String comment, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/ruklas.png'),
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

  Widget _buildCommentInputField(String imagePath) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/ruklas.png'),
            radius: 35,
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
