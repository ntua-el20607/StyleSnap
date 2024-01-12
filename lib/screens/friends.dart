import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  const Friends({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 430,
          height: 932,
          child: Stack(
            children: [
              buildBackgroundContainer(),
              buildTopFriendsText(),
              buildDivider(),
              buildFriendsHeader(),
              ...buildProfileImages(),
              buildStats(),
              buildBottomNavigationBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBackgroundContainer() {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget buildTopFriendsText() {
    return Positioned(
      left: 136,
      top: 398,
      child: Text(
        'Top Friends',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontFamily: 'Ribeye Marrow',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget buildDivider() {
    // Similar function for the divider
  }

  Widget buildFriendsHeader() {
    // Similar function for the FRIENDS header
  }

  List<Widget> buildProfileImages() {
    // A function to build the profile images
  }

  Widget buildStats() {
    // A function to build the stats like 'Top Casual Outfits: 89'
  }

  Widget buildBottomNavigationBar() {
    // A function to build the bottom navigation bar
  }
}
