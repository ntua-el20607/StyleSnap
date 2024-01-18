import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Post.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/nearme.dart';
import 'package:stylesnap/screens/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylesnap/screens/FriendProfile.dart'; // Import the FriendProfile screen

class ScrollableImageRow extends StatelessWidget {
  const ScrollableImageRow({Key? key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String currentUserId = currentUser?.uid ?? '';
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUserId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            List<dynamic> friendsList = snapshot.data!.get('friends') ?? [];

            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: friendsList.length,
                itemBuilder: (BuildContext context, int index) {
                  String friendId = friendsList[index];

                  return FutureBuilder<DocumentSnapshot>(
                    future: users.doc(friendId).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> friendSnapshot) {
                      if (friendSnapshot.connectionState ==
                          ConnectionState.done) {
                        if (friendSnapshot.hasError) {
                          return Container(
                            child: Text('Error: ${friendSnapshot.error}'),
                          );
                        }

                        if (friendSnapshot.hasData) {
                          Map<String, dynamic> friendData = friendSnapshot.data!
                              .data() as Map<String, dynamic>;

                          String profilePictureUrl =
                              friendData.containsKey('profilePictureUrl')
                                  ? friendData['profilePictureUrl'] ?? ''
                                  : '';
                          String friendUsername = friendData['username'] ?? '';

                          if (profilePictureUrl.isNotEmpty) {
                            // Display friend's profile picture with GestureDetector for navigation
                            return GestureDetector(
                              onTap: () async {
                                print(
                                    "Fetching details for friendId: $friendId"); // Check the friendId
                                var friendDetails =
                                    await getUserDetails(friendId);
                                print(
                                    "Friend details fetched: $friendDetails"); // Check the fetched details

                                if (friendDetails.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => friendprof(
                                        userId: friendId,
                                        fullName: friendDetails['fullName'],
                                        email: friendDetails['email'],
                                        phoneNumber:
                                            friendDetails['phoneNumber'],
                                        username: friendDetails['username'],
                                      ),
                                    ),
                                  );
                                } else {
                                  print(
                                      "No user details found for friendId: $friendId");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(profilePictureUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      friendUsername,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Display default local picture when profilePictureUrl is empty
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/profile_pic.png'), // Change to your default local picture
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    friendUsername,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Container(); // Handle when friend document does not exist
                        }
                      } else {
                        return Container(); // Handle while friend document is being fetched
                      }
                    },
                  );
                },
              ),
            );
          } else {
            return Container(); // Handle when user document does not exist
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
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
}

class Friends extends StatelessWidget {
  const Friends({Key? key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String currentUserId = currentUser?.uid ?? '';
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUserId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          if (snapshot.hasData) {
            List<dynamic> friendsList = snapshot.data!.get('friends') ?? [];

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    friendsList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                'FRIENDS',
                                style: TextStyle(
                                  color: Color(0xFF471AA0),
                                  fontSize: 30,
                                  fontFamily: 'Ribeye',
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? SizedBox(
                            height: 200,
                            child: ScrollableImageRow(),
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? Container()
                        : const SizedBox(
                            height: 350,
                          ),
                    friendsList.isNotEmpty
                        ? Container()
                        : Center(
                            child: Text(
                              'No friends yet',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    friendsList.isNotEmpty
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Nearme(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                            ),
                            child: Text(
                              'Search for friends',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                    friendsList.isNotEmpty
                        ? Column(
                            children: [
                              buildTopFriendsText(context),
                              // Add other features/widgets here
                              // ...
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              bottomNavigationBar: _buildBottomNavigationBar(context),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('User document not found for ID: $currentUserId'),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildBackgroundContainer() {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget buildTopFriendsText(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Top Friends',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Ribeye Marrow',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 4, // Space between text and line
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 2,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget buildTextWithImage(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profile_pic.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Home") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeCasuals()),
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
            style: const TextStyle(
              color: Colors.purple,
            ),
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
