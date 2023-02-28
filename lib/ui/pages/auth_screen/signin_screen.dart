// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/ui/entryPoint/entry_point.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/forgot_password_screen.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/signup_screen.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool obscureTextValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              children: [
                Text(
                  "Chào mừng quay trở lại!",
                  style: OneTheme.of(context).header.copyWith(color: OneColors.black, fontSize: 25),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Hãy thực hiện đăng nhập để có thể tiếp tục hành trình, khám phá, tìm hiểu về vũ trụ bao la rộng lớn!",
                  style: OneTheme.of(context).title2.copyWith(color: OneColors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng không bỏ trống!';
                          }
                          // Kiểm tra định dạng email bằng RegExp
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Nhập sai định dạng email!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText: "Mật khẩu",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: obscureTextValue ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscureTextValue = !obscureTextValue;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng không bỏ trống!';
                          } else if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 kí tự';
                          }
                          return null;
                        },
                        obscureText: obscureTextValue,
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                Get.to(() => const ForgotPasswordScreen());
                              },
                              child: const Text("Quên mật khẩu?"))),
                      const SizedBox(height: 16.0),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              Get.to(() => const BottomNavigationBarWidget(), curve: Curves.linear, transition: Transition.rightToLeft, duration: const Duration(milliseconds: 200));
                            } on FirebaseAuthException catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: OneColors.red,
                                  content: Text("Email hoặc Password không hợp lệ! Hãy thử lại"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } on PlatformException catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: OneColors.red,
                                  content: Text("Email hoặc Password không hợp lệ! Hãy thử lại"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(image: AssetImage(OneImages.bg4), fit: BoxFit.fitWidth),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                                child: Text(
                              'Đăng nhập',
                              style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                Get.to(() => const RegisterPage());
              },
              child: const Text("Chưa có tài khoản? Đăng ký"))
        ],
      ),
    );
  }
}
