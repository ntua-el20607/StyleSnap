import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stylesnap/screens/Profile.dart';
import 'package:stylesnap/screens/friendprofile.dart';
import 'package:stylesnap/screens/friends.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/post.dart';
import 'package:stylesnap/screens/addfriend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Nearme extends StatefulWidget {
  const Nearme({super.key});

  @override
  State<Nearme> createState() => _NearmeState();
}

class _NearmeState extends State<Nearme> {
  Set<Marker> _markers = {};
  late GoogleMapController mapController;
  LatLng _initialCameraPosition =
      const LatLng(20.5937, 78.9629); // Default location
  Location location = Location();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchPostsAndCreateMarkers();
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

    if (!mounted) return;

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

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : '';
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
              markers: _markers,
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
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: searchBarHeight / 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              onSearch(searchController.text);
            },
          ),
        ),
        onSubmitted: (value) {
          onSearch(value);
        },
      ),
    );
  }

  Future<void> onSearch(String username) async {
    var userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (userQuery.docs.isNotEmpty) {
      var userDoc = userQuery.docs.first;
      var searchedUserId = userDoc.id;
      var userData = userDoc.data();

      String fullName = userData['fullName'] ?? 'N/A';
      String email = userData['email'] ?? 'N/A';
      String phoneNumber = userData['phoneNumber'] ?? 'N/A';

      // Check if the searched user is the current user
      String currentUserId = getCurrentUserId();
      if (searchedUserId == currentUserId) {
        // Navigate to the user's own profile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      } else {
        // Check if the searched user is in the current user's friends list
        var currentUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();

        List<dynamic> friends = currentUserDoc.data()?['friends'] ?? [];

        if (friends.contains(searchedUserId)) {
          // Navigate to the FriendProfile screen with user details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => friendprof(
                userId: searchedUserId,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                username: username,
              ),
            ),
          );
        } else {
          // If the user is not a friend, navigate to the AddFriend screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => addfriend(
                userId: searchedUserId,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                username: username,
              ),
            ),
          );
        }
      }
    } else {
      // Show an error or a message saying user not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> searchUser(String username) async {
    var userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return userQuery.docs.isNotEmpty;
  }

  void _fetchPostsAndCreateMarkers() async {
    var postsSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    for (var doc in postsSnapshot.docs) {
      var data = doc.data();
      var location = data['location'] as GeoPoint;
      var userId = data['userId'];

      if (!mounted) return;

      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(location.latitude, location.longitude),
          onTap: () => _showUserDetails(userId),
        ));
      });
    }
  }

  void _showUserDetails(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      var userData = userDoc.data();
      if (userData != null) {
        // Add the userId to the userData map
        userData['userId'] = userId;
        print("Fetched userData with userId: $userData");
        _showBottomSheet(context, userData);
      } else {
        print("User data is null");
      }
    } else {
      print("User document does not exist");
    }
  }

  void _showBottomSheet(BuildContext context, Map<String, dynamic>? userData) {
    if (userData == null) {
      // Handle the case where userData is null
      // For example, you can show an error message or close the bottom sheet
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data not available.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                _buildBottomSheetHeader(context),
                Expanded(
                  child: ListView(
                    controller: controller,
                    children: [
                      _buildUserProfile(userData),
                      _buildViewProfileButton(context, userData),
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

  Widget _buildBottomSheetHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8, // Adjust height as needed
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5, // Make the line thinner
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 60,
          height: 7,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(Map<String, dynamic> userData) {
    // Safely cast the profile picture URL as a string, or null if it's not available
    String? profilePicUrl = userData['profilePictureUrl'] as String?;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60, // Adjust the size as needed
          backgroundImage: profilePicUrl != null && profilePicUrl.isNotEmpty
              ? NetworkImage(profilePicUrl) as ImageProvider
              : const AssetImage(
                  'assets/images/profile_pic.png'), // Default profile picture
          backgroundColor:
              Colors.grey, // Fallback color if the image fails to load
        ),
        const SizedBox(height: 8),
        Text(
          userData['username'] ??
              'Username', // Fallback text in case username is null
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildViewProfileButton(
      BuildContext context, Map<String, dynamic> userData) {
    String? userId = userData['userId'];

    if (userId == null) {
      return SizedBox.shrink(); // Return an empty widget if userId is null
    }

    double buttonWidth = MediaQuery.of(context).size.width * 0.6;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: SizedBox(
          width: buttonWidth, // Set the button width
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF9747FF), // Background color
              onPrimary: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Optional: Rounded corners
              ),
            ),
            onPressed: () async {
              if (userId == getCurrentUserId()) {
                // If the user is viewing their own profile, navigate to ProfileScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              } else {
                // If viewing someone else's profile, check if they are a friend
                bool isFriend = await _checkIfUserIsFriend(userId);
                if (isFriend) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => friendprof(
                        userId: userId,
                        fullName: userData['fullName'],
                        email: userData['email'],
                        phoneNumber: userData['phoneNumber'],
                        username: userData['username'],
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addfriend(
                        userId: userId,
                        fullName: userData['fullName'],
                        email: userData['email'],
                        phoneNumber: userData['phoneNumber'],
                        username: userData['username'],
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('View Profile'),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkIfUserIsFriend(String userId) async {
    String currentUserId = getCurrentUserId();
    var currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    List<dynamic> friends = currentUserDoc.data()?['friends'] ?? [];
    return friends.contains(userId);
  }

  @override
  void dispose() {
    // Dispose your controllers, listeners, etc. here
    mapController.dispose();
    // Dispose other resources if needed

    super.dispose(); // Always call super.dispose() at the end
  }
}
