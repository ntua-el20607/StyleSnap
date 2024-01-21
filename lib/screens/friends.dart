import 'package:flutter/material.dart';
import 'package:stylesnap/screens/Post.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/nearme.dart';
import 'package:stylesnap/screens/profile.dart';
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
                                      style: const TextStyle(
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
                                    decoration: const BoxDecoration(
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
                                    style: const TextStyle(
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
          return const CircularProgressIndicator();
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
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

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
                        ? const Padding(
                            padding: EdgeInsets.only(top: 20),
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
                        ? const SizedBox(
                            height: 200,
                            child: ScrollableImageRow(),
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? Column(
                            children: [
                              buildTopFriendsText(context),
                              FutureBuilder<Map<String, int>>(
                                future: fetchFriendPostStatistics(
                                  currentUserId,
                                  friendsList,
                                  posts,
                                  photoType:
                                      'Casual', // Specify the photoType as 'Casual'
                                ),
                                builder: (context, postStatsSnapshot) {
                                  if (postStatsSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (postStatsSnapshot.hasError) {
                                      return Container(
                                        child: Text(
                                            'Error: ${postStatsSnapshot.error}'),
                                      );
                                    }

                                    Map<String, int>? postStatistics =
                                        postStatsSnapshot.data;

                                    if (postStatistics != null) {
                                      // Find friend with the most casual posts
                                      String friendWithMostCasualPosts = '';
                                      int maxCasualPostCount = 0;

                                      postStatistics.forEach((friendId, count) {
                                        if (count > maxCasualPostCount) {
                                          maxCasualPostCount = count;
                                          friendWithMostCasualPosts = friendId;
                                        }
                                      });

                                      if (maxCasualPostCount > 0) {
                                        // Display information about the friend with the most casual posts
                                        return Column(
                                          children: [
                                            SizedBox(height: 40),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: users
                                                  .doc(
                                                      friendWithMostCasualPosts)
                                                  .get(),
                                              builder:
                                                  (context, friendSnapshot) {
                                                if (friendSnapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  if (friendSnapshot.hasError) {
                                                    return Container(
                                                      child: Text(
                                                          'Error: ${friendSnapshot.error}'),
                                                    );
                                                  }

                                                  if (friendSnapshot.hasData) {
                                                    Map<String, dynamic>
                                                        friendData =
                                                        friendSnapshot.data!
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;

                                                    String profilePictureUrl =
                                                        friendData.containsKey(
                                                                'profilePictureUrl')
                                                            ? friendData[
                                                                    'profilePictureUrl'] ??
                                                                ''
                                                            : '';
                                                    int casualPostCount =
                                                        postStatistics[
                                                                friendWithMostCasualPosts] ??
                                                            0;

                                                    return Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Most Casual Posts: $casualPostCount',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            width: 150),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 40,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      profilePictureUrl),
                                                            ),
                                                            const SizedBox(
                                                                height: 3),
                                                            Text(
                                                              friendData[
                                                                  'username'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                }

                                                return Container();
                                              },
                                            ),
                                          ],
                                        );
                                      } else {
                                        // Display a message when none of the friends have casual posts
                                        return Column(
                                          children: [
                                            SizedBox(height: 40),
                                            Text(
                                              'No Casual post stats yet.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  }

                                  return Container(); // Handle loading state or empty state
                                },
                              ),
                            ],
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? Column(
                            children: [
                              FutureBuilder<Map<String, int>>(
                                future: fetchFriendPostStatistics(
                                  currentUserId,
                                  friendsList,
                                  posts,
                                  photoType:
                                      'Formal', // Specify the photoType as 'Formal'
                                ),
                                builder: (context, postStatsSnapshot) {
                                  if (postStatsSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (postStatsSnapshot.hasError) {
                                      return Container(
                                        child: Text(
                                            'Error: ${postStatsSnapshot.error}'),
                                      );
                                    }

                                    Map<String, int>? postStatistics =
                                        postStatsSnapshot.data;

                                    if (postStatistics != null) {
                                      // Find friend with the most formal posts
                                      String friendWithMostFormalPosts = '';
                                      int maxFormalPostCount = 0;

                                      postStatistics.forEach((friendId, count) {
                                        if (count > maxFormalPostCount) {
                                          maxFormalPostCount = count;
                                          friendWithMostFormalPosts = friendId;
                                        }
                                      });

                                      if (maxFormalPostCount > 0) {
                                        // Display information about the friend with the most formal posts
                                        return Column(
                                          children: [
                                            SizedBox(height: 40),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: users
                                                  .doc(
                                                      friendWithMostFormalPosts)
                                                  .get(),
                                              builder:
                                                  (context, friendSnapshot) {
                                                if (friendSnapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  if (friendSnapshot.hasError) {
                                                    return Container(
                                                      child: Text(
                                                          'Error: ${friendSnapshot.error}'),
                                                    );
                                                  }

                                                  if (friendSnapshot.hasData) {
                                                    Map<String, dynamic>
                                                        friendData =
                                                        friendSnapshot.data!
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;

                                                    String profilePictureUrl =
                                                        friendData.containsKey(
                                                                'profilePictureUrl')
                                                            ? friendData[
                                                                    'profilePictureUrl'] ??
                                                                ''
                                                            : '';
                                                    int formalPostCount =
                                                        postStatistics[
                                                                friendWithMostFormalPosts] ??
                                                            0;

                                                    return Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Most Formal Posts: $formalPostCount',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            width: 150),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 40,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      profilePictureUrl),
                                                            ),
                                                            const SizedBox(
                                                                height: 3),
                                                            Text(
                                                              friendData[
                                                                  'username'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                }

                                                return Container();
                                              },
                                            ),
                                          ],
                                        );
                                      } else {
                                        // Display a message when none of the friends have formal posts
                                        return Column(
                                          children: [
                                            SizedBox(height: 40),
                                            Text(
                                              'No formal post stats yet.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  }

                                  return Container(); // Handle loading state or empty state
                                },
                              ),
                            ],
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? Column(
                            children: [
                              FutureBuilder<Map<String, int>>(
                                future: fetchFriendRatingStatistics(
                                  currentUserId,
                                  friendsList,
                                  posts,
                                ),
                                builder: (context, ratingStatsSnapshot) {
                                  if (ratingStatsSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (ratingStatsSnapshot.hasError) {
                                      return Container(
                                        child: Text(
                                            'Error: ${ratingStatsSnapshot.error}'),
                                      );
                                    }

                                    Map<String, int>? ratingStatistics =
                                        ratingStatsSnapshot.data;

                                    if (ratingStatistics != null) {
                                      // Find friend with the most ratings
                                      String friendWithMostRatings = '';
                                      int maxRatingCount = 0;

                                      ratingStatistics
                                          .forEach((friendId, count) {
                                        if (count > maxRatingCount) {
                                          maxRatingCount = count;
                                          friendWithMostRatings = friendId;
                                        }
                                      });

                                      if (maxRatingCount > 0) {
                                        // Display information about the friend with the most ratings
                                        return Column(
                                          children: [
                                            SizedBox(height: 40),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: users
                                                  .doc(friendWithMostRatings)
                                                  .get(),
                                              builder:
                                                  (context, friendSnapshot) {
                                                if (friendSnapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  if (friendSnapshot.hasError) {
                                                    return Container(
                                                      child: Text(
                                                          'Error: ${friendSnapshot.error}'),
                                                    );
                                                  }

                                                  if (friendSnapshot.hasData) {
                                                    Map<String, dynamic>
                                                        friendData =
                                                        friendSnapshot.data!
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;

                                                    String profilePictureUrl =
                                                        friendData.containsKey(
                                                                'profilePictureUrl')
                                                            ? friendData[
                                                                    'profilePictureUrl'] ??
                                                                ''
                                                            : '';
                                                    int ratingCount =
                                                        ratingStatistics[
                                                                friendWithMostRatings] ??
                                                            0;

                                                    return Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Most Rates to Your Posts: $ratingCount',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            width: 95),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 40,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      profilePictureUrl),
                                                            ),
                                                            const SizedBox(
                                                                height: 3),
                                                            Text(
                                                              friendData[
                                                                  'username'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                }

                                                return Container();
                                              },
                                            ),
                                          ],
                                        );
                                      } else {
                                        // Display a message when none of the friends have rated posts
                                        return Column(
                                          children: [
                                            SizedBox(height: 40),
                                            Text(
                                              'No one friend rated any of your posts yet.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  }

                                  return Container(); // Handle loading state or empty state
                                },
                              ),
                            ],
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? FutureBuilder<Map<String, int>>(
                            future: fetchFriendPostStatistics(
                              currentUserId,
                              friendsList,
                              posts,
                            ),
                            builder: (context, postStatsSnapshot) {
                              if (postStatsSnapshot.connectionState ==
                                  ConnectionState.done) {
                                if (postStatsSnapshot.hasError) {
                                  return Container(
                                    child: Text(
                                        'Error: ${postStatsSnapshot.error}'),
                                  );
                                }

                                Map<String, int>? postStatistics =
                                    postStatsSnapshot.data;

                                if (postStatistics != null) {
                                  return Column(
                                    children: [
                                      // Display friend post statistics

                                      SizedBox(height: 3),
                                      // Iterate over friends and display statistics
                                    ],
                                  );
                                }
                              }

                              return Container(); // Handle loading state or empty state
                            },
                          )
                        : Container(),
                    friendsList.isNotEmpty
                        ? Container()
                        : const SizedBox(
                            height: 350,
                          ),
                    friendsList.isNotEmpty
                        ? Container()
                        : const Center(
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
                              backgroundColor: Colors.purple,
                            ),
                            child: const Text(
                              'Search for friends',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, int>> fetchFriendPostStatistics(String currentUserId,
      List<dynamic> friendsList, CollectionReference posts,
      {String? photoType}) async {
    Map<String, int> postStatistics = {};

    try {
      for (String friendId in friendsList) {
        // Fetch all posts
        QuerySnapshot allPostsSnapshot = await posts.get();

        // Count the number of posts where the friend's ID matches the post's userID
        int postCount = 0;

        for (QueryDocumentSnapshot postDoc in allPostsSnapshot.docs) {
          Map<String, dynamic> postData =
              postDoc.data() as Map<String, dynamic>;

          // Check if the userID in the post matches the friend's ID and the photoType matches
          if (postData['userId'] == friendId &&
              postData['photoType'] == photoType) {
            postCount++;
          }
        }

        // Store the count in the postStatistics map
        postStatistics[friendId] = postCount;
      }

      return postStatistics;
    } catch (e) {
      print('Error fetching friend post statistics: $e');
      return postStatistics; // Return an empty map in case of an error
    }
  }

  Future<Map<String, int>> fetchFriendRatingStatistics(String currentUserId,
      List<dynamic> friendsList, CollectionReference posts) async {
    Map<String, int> ratingStatistics = {};

    try {
      // Fetch all posts by the current user
      QuerySnapshot userPostsSnapshot =
          await posts.where('userId', isEqualTo: currentUserId).get();

      // Iterate through the user's posts
      for (QueryDocumentSnapshot postDoc in userPostsSnapshot.docs) {
        String postId = postDoc.id;

        // Check if the post has a 'ratings' subcollection
        QuerySnapshot ratingsSnapshot =
            await postDoc.reference.collection('ratings').get();

        if (ratingsSnapshot.docs.isNotEmpty) {
          // Count the number of ratings by each friend
          for (QueryDocumentSnapshot ratingDoc in ratingsSnapshot.docs) {
            String friendId = ratingDoc.id;

            // Check if the friend is in the friendsList
            if (friendsList.contains(friendId)) {
              // Increment the rating count for the friend
              ratingStatistics.update(friendId, (count) => count + 1,
                  ifAbsent: () => 1);
            }
          }
        }
      }

      return ratingStatistics;
    } catch (e) {
      print('Error fetching friend rating statistics: $e');
      return ratingStatistics; // Return an empty map in case of an error
    }
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
}
