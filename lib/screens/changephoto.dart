import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePhotoScreen extends StatefulWidget {
  const ChangePhotoScreen({Key? key, required this.onPhotoTaken})
      : super(key: key);

  final Function(String?) onPhotoTaken;

  @override
  _ChangePhotoScreenState createState() => _ChangePhotoScreenState();
}

class _ChangePhotoScreenState extends State<ChangePhotoScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRearCameraSelected = true;
  bool _isFlashOn = false;

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
          imageFormatGroup: ImageFormatGroup.jpeg);
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

      // Upload photo to Firebase Storage
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
      await storageRef.putFile(File(photo.path));

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Save download URL to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profilePictureUrl': downloadUrl});

      // Trigger the callback with the photo path
      widget.onPhotoTaken(downloadUrl);

      // Navigate back to ProfileScreen after taking a photo
      Navigator.pop(context);
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
        title: const Text('StyleSnap',
            style: TextStyle(color: Colors.white, fontSize: 20)),
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
                    Expanded(child: Container()),
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
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
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
