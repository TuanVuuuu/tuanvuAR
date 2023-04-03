import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/src/shared/contant.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/signin_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/signup_screen.dart';
import 'package:get/get.dart';

class LoginManagerScreen extends StatefulWidget {
  const LoginManagerScreen({super.key});

  @override
  State<LoginManagerScreen> createState() => _LoginManagerScreenState();
}

class _LoginManagerScreenState extends State<LoginManagerScreen> {
  @override
  Widget build(BuildContext context) {

    AppContants.init(context);
    
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    image: AssetImage(
                      OneImages.bg3,
                    ),
                    fit: BoxFit.fitWidth)),
            child: Container(
              height: AppContants.sizeHeight * 0.5,
              decoration: BoxDecoration(
                  // color: OneColors.blue200,
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      image: AssetImage(
                    OneImages.login_svg,
                  ))),
            ),
          ),
          const Spacer(),
          Text(
            "Tìm hiểu không gian\n ngoài vũ trụ rộng lớn",
            style: OneTheme.of(context).header.copyWith(color: OneColors.black),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Ứng dụng thiên văn học thực tế ảo - công cụ giúp người dùng khám phá và tìm hiểu về vũ trụ thông qua các trải nghiệm trực quan và ảo hóa thực tế.",
              style: OneTheme.of(context).body2.copyWith(letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                          color: OneColors.blue200,
                          image: DecorationImage(
                              image: AssetImage(
                                OneImages.bg3,
                              ),
                              fit: BoxFit.fitWidth)),
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.LOGIN_SCREEN.name);
                          // Get.to(() => const LoginPage(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
                        },
                        child: Text(
                          "Đăng nhập",
                          style: OneTheme.of(context).header.copyWith(
                                color: OneColors.white,
                              ),
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                        color: OneColors.greyLight,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.REGISTER_PAGE.name);
                          // Get.to(() => const RegisterPage(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
                        },
                        child: Text(
                          "Đăng Ký",
                          style: OneTheme.of(context).header.copyWith(
                                color: OneColors.black,
                              ),
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
