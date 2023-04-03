// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/sign_out.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserDetailInfoScreen extends StatefulWidget {
  const UserDetailInfoScreen({super.key});

  @override
  State<UserDetailInfoScreen> createState() => _UserDetailInfoScreenState();
}

class _UserDetailInfoScreenState extends State<UserDetailInfoScreen> {
  final User? users = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _usersdataDataList = [];
  bool isLoading = true;
  bool isEditing = false;
  late TextEditingController _nameController;
  Map<String, dynamic>? _mapCurrentUser;
  File? _image;
  final picker = ImagePicker();
  bool isPickImage = false;

  @override
  void dispose() {
    super.dispose();
    picker;
    _image;
    _nameController;
    updateUserAvatarUrl;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadCurrentUser();
    getUserData().then((usersdata) {
      setState(() {
        isLoading = false;
        _usersdataDataList = usersdata;
      });
    });
  }

  Future<void> updateUserData(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = {'name': newName};
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update(userData);
  }

  @override
  Widget build(BuildContext context) {
    AppContants.init(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(OneImages.bg4),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: OneColors.transparent,
        appBar: AppBar(
          backgroundColor: OneColors.transparent,
          elevation: 0,
          leading: _buildBackButton(context),
          actions: [
            _buildEditButton(context),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(context),
            const SizedBox(height: 15),
            Column(
              children: [
                if (isEditing) ...[
                  _buildEditUserName(context),
                ] else ...[
                  _buildUserName(context, "name", null),
                ],
              ],
            ),
            const SizedBox(height: 15),
            _buildCardUser(context, "NickName", "name"),
            _buildCardUser(context, "Điểm kinh nghiệm (EXP)", "scores"),
            _buildCardUser(context, "Email", "email"),
            const Spacer(),
            _buildLogout(context),
          ],
        ),
      ),
    );
  }

  IconButton _buildEditButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (isEditing) {
          if (_nameController.text.isEmpty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                title: const Text('Thông báo'),
                content: const Text('Vui lòng không bỏ trống!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            await updateUserData(_nameController.text);
            final newData = {'name': _nameController.text, 'email': users!.email};
            setState(() {
              _usersdataDataList = [_usersdataDataList.firstWhere((element) => element["email"] != users!.email), newData];
              isEditing = false;
            });
          }
        } else {
          setState(() {
            isEditing = true;
          });
        }
      },
      icon: Icon(isEditing ? Icons.check : Icons.edit),
    );
  }

  InkWell _buildLogout(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.SIGN_OUT.name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: OneColors.black100.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: OneColors.white,
            ),
            const SizedBox(width: 5),
            Text(
              "Đăng xuất",
              style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildCardUser(BuildContext context, String title, String feild) {
    return Container(
      decoration: BoxDecoration(color: OneColors.black100.withOpacity(0.7), borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: OneTheme.of(context).body1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          _buildUserName(
            context,
            feild,
            OneTheme.of(context).title1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Column _buildUserName(BuildContext context, String feild, style) {
    return Column(
      children: _usersdataDataList
          .where((element) => element["email"] == users!.email)
          .take(1)
          .map(
            (e) => Text(
              "${e[feild]}",
              style: style ?? OneTheme.of(context).header.copyWith(color: OneColors.white),
            ),
          )
          .toList(),
    );
  }

  Padding _buildEditUserName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: "NickName",
          hintStyle: OneTheme.of(context).body1.copyWith(color: OneColors.white),
          prefixIcon: const Icon(
            Icons.person,
            color: OneColors.white,
          ),
        ),
        style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
        maxLength: 25,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Vui lòng không bỏ trống!';
          }
          return null;
        },
      ),
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: OneColors.white,
        ));
  }

  Center _buildAvatar(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 70),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: SizedBox(
          width: AppContants.sizeHeight * 0.3,
          height: AppContants.sizeHeight * 0.3,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              (_mapCurrentUser != null && _mapCurrentUser?["avatarUrl"] != "")
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        _mapCurrentUser?["avatarUrl"],
                      ),
                      radius: AppContants.sizeHeight * 0.15,
                    )
                  : Container(
                      height: AppContants.sizeHeight * 0.3,
                      width: AppContants.sizeHeight * 0.4,
                      decoration: const BoxDecoration(
                        color: OneColors.blue300,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(OneImages.avatars),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    getImage();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        content: SizedBox(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: Text(
                                  'Chú ý!',
                                  style: OneTheme.of(context).title1.copyWith(color: OneColors.blue200),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Ảnh đại diện của bạn sẽ được thay đổi',
                                style: OneTheme.of(context).title2.copyWith(color: OneColors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Huỷ'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              handleUpload();
                            },
                            child: const Text('Tiếp tục'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: AppContants.sizeHeight * 0.1,
                    decoration: BoxDecoration(
                        color: OneColors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                        )),
                    child: const Center(
                      child: Icon(
                        Icons.add_a_photo,
                        color: OneColors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _loadCurrentUser() async {
    final Map<String, dynamic> leaderboard = await getCurrentUser();
    setState(() {
      _mapCurrentUser = leaderboard;
    });
  }

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          content: SizedBox(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    'Thành công',
                    style: OneTheme.of(context).title1.copyWith(color: OneColors.blue200),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Ảnh đại diện của bạn đã được đặt lại thành công! Sẽ mất 1 đến 2 phút để ảnh đại diện của bạn có thể được cập nhật',
                  style: OneTheme.of(context).title2.copyWith(color: OneColors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Thoát'),
            ),
          ],
        ),
      );
    }
  }
}
