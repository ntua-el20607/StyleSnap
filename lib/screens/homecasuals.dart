import 'package:flutter/material.dart';
import 'package:stylesnap/screens/commets.dart';
import 'package:stylesnap/screens/homeformals.dart';

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
                child: _buildArrowIcon(),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset("assets/images/casual.png", fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(), // Spacer on the left
                          _buildStarRating(index),
                          const Spacer(), // Spacer on the right for centering the stars
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: _buildCommentIcon(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.purple), // Set the icon color to purple
        Text(
          label,
          style: const TextStyle(
              color: Colors.purple), // Set the text color to purple
        ),
      ],
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
          // Action for your button
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

  Widget _buildCommentIcon() {
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
      isScrollControlled: true, // Set to true for full screen modal
      builder: (BuildContext bc) {
        return const Comments(); // Your Comments widget
      },
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      width: 30, // Adjust size as needed
      height: 30, // Adjust size as needed
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2), // Purple border
        shape: BoxShape.rectangle, // Square shape
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_forward,
            color: Colors.purple, size: 24), // Adjust icon size as needed
        padding: EdgeInsets.zero, // Remove any default padding
        alignment: Alignment.center, // Center the icon
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HomeFormals()), // Navigate to HomeCasuals page
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
