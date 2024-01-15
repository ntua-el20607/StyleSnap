import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stylesnap/screens/homecasuals.dart';
import 'package:stylesnap/screens/homeformals.dart'; // Add this import

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRearCameraSelected = true;
  bool _isFlashOn = false;

  bool _isCasualButtonPressed = false;
  bool _isFormalButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _isRearCameraSelected ? _cameras![0] : _cameras![1],
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      _isRearCameraSelected = !_isRearCameraSelected;
      await _initCamera();
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller != null) {
      _isFlashOn = !_isFlashOn;
      await _controller!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final XFile photo = await _controller!.takePicture();

      // Save the photo to Firebase Storage and get the download URL
      var photoUrl = await _savePhotoToStorage(photo.path);

      // Save the photo URL to Firestore
      await savePhotoInfoToFirestore(
          photoUrl, _isCasualButtonPressed ? 'Casual' : 'Formal');

      // Determine the screen to navigate based on the button press
      if (_isCasualButtonPressed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeCasuals()),
        );
      } else if (_isFormalButtonPressed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeFormals()),
        );
      }
    }
  }

  Future<String> _savePhotoToStorage(String photoPath) async {
    // Implement your logic to save the photo to Firebase Storage
    // You'll get the download URL after successfully uploading the photo
    // ...

    // For now, let's assume you have a function that uploads the photo to storage
    String downloadUrl = await uploadPhotoToStorage(photoPath);

    return downloadUrl;
  }

  Future<void> savePhotoInfoToFirestore(
      String photoUrl, String photoType) async {
    // Get the current user
    var user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Save the photo info to the "photos" subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('photos')
          .add({
        'photoUrl': photoUrl,
        'photoType': photoType,
        // Other fields...
      });
    }
  }

  Future<String> uploadPhotoToStorage(String photoPath) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = storage.ref().child('photos/$fileName.jpg');

      // Upload the file to Firebase Storage
      await storageReference.putFile(File(photoPath));

      // Get the download URL
      String downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print('Error uploading photo: $error');
      return ''; // Handle the error appropriately in your app
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'StyleSnap',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w100,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                Column(
                  children: [
                    SizedBox(
                        height: AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.top),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 2,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isCasualButtonPressed
                                    ? Colors
                                        .green // Change the color if pressed
                                    : const Color(0xFF9747FF),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(20),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isCasualButtonPressed = true;
                                    _isFormalButtonPressed = false;
                                  });
                                },
                                child: const Text(
                                  "Casual",
                                  style: TextStyle(
                                    fontFamily: "Rochester",
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isFormalButtonPressed
                                    ? Colors
                                        .green // Change the color if pressed
                                    : const Color(0xFF9747FF),
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(20),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isCasualButtonPressed = false;
                                    _isFormalButtonPressed = true;
                                  });
                                },
                                child: const Text(
                                  "Formal",
                                  style: TextStyle(
                                    fontFamily: "Rochester",
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 2,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isFlashOn ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: _toggleFlash,
                          ),
                          GestureDetector(
                            onTap: _takePicture,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: _toggleCamera,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
