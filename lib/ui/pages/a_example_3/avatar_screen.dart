// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();

  // Function to handle image selection from gallery
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to upload image to Firebase Storage
  Future<String> uploadImageToFirebase(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference reference = storage.ref().child('avatars/$fileName');

    UploadTask uploadTask = reference.putFile(image);

    TaskSnapshot storageTaskSnapshot = await uploadTask;

    // Get the download URL of the uploaded image
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  // Function to update avatarUrl field of user in Firestore
  Future<void> updateUserAvatarUrl(String downloadUrl) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'avatarUrl': downloadUrl,
    });
  }

  // Function to handle upload button press
  Future<void> handleUpload() async {
    if (_image != null) {
      String downloadUrl = await uploadImageToFirebase(_image!);
      await updateUserAvatarUrl(downloadUrl);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thành công!'),
          content: const Text('Ảnh đại diện của bạn đã được đặt lại thành công!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đồng ý'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: getImage,
              child: CircleAvatar(
                backgroundImage: _image != null ? FileImage(_image!) : null,
                radius: 60,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleUpload,
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
