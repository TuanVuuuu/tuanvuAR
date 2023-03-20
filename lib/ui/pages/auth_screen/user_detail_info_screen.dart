import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/firestore_helper.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/sign_out.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
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
        Get.to(() => SignOutScreen(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
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
          hintText: "Nickname",
          hintStyle: OneTheme.of(context).body1.copyWith(color: OneColors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          alignLabelWithHint: true,
          prefixIcon: const Icon(
            Icons.person,
            color: OneColors.blue300,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
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
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: OneColors.blue300,
          shape: BoxShape.circle,
        ),
        child: Image.asset(OneImages.avatars),
      ),
    );
  }
}
