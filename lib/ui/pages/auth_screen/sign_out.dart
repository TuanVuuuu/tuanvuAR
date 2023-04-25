// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:get/get.dart';

class SignOutScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  SignOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng xuất',
          style: OneTheme.of(context).header,
        ),
        backgroundColor: OneColors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: OneColors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bạn chắc chắn muốn đăng xuất chứ?",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Get.toNamed(AppRoutes.LOGIN_SCREEN.name);
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                width: AppContants.sizeWidth,
                margin: const EdgeInsets.symmetric(horizontal: 70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage(OneImages.bg4), fit: BoxFit.fitWidth),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Text(
                    'Tiếp tục',
                    style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
