import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/post.dart';

class Nearme extends StatefulWidget {
  const Nearme({super.key});

  @override
  State<Nearme> createState() => _NearmeState();
}

class _NearmeState extends State<Nearme> {
  late GoogleMapController mapController;
  LatLng _initialCameraPosition =
      const LatLng(20.5937, 78.9629); // Default location
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var locationData = await location.getLocation();
    setState(() {
      _initialCameraPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 15.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialCameraPosition,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: buildSearchBar(context),
                ),
                _buildBottomNavigationBar(context),
              ],
            ),
          ],
        ),
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

  Widget buildSearchBar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarWidth = screenWidth * 0.9;
    double searchBarHeight = searchBarWidth / 8;

    return Container(
      width: searchBarWidth,
      height: searchBarHeight,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05), // Adjusted for better centering
      child: TextField(
        decoration: InputDecoration(
          prefixIcon:
              const Icon(Icons.search, color: Colors.grey), // Grey search icon
          hintText: 'Search...',
          hintStyle:
              const TextStyle(color: Colors.grey), // Grey placeholder text
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
              vertical: searchBarHeight / 4), // Center the text vertically
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onTap: () {
          // Perform action on tap if needed
        },
      ),
    );
  }
}
