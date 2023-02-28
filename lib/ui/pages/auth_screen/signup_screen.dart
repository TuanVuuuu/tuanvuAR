// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/signin_screen.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool obscureTextValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Builder(
            builder: (context) => Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Tạo tài khoản mới!",
                        style: OneTheme.of(context).header.copyWith(color: OneColors.black, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hãy thực hiện đăng ký tài khoản để có thể bắt đầu hành trình, khám phá, tìm hiểu về vũ trụ bao la rộng lớn!",
                        style: OneTheme.of(context).title2.copyWith(color: OneColors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Nickname",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng không bỏ trống!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
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
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
                              'email': _emailController.text,
                              'name': _nameController.text,
                              'scores': 0,
                            });
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                content: SizedBox(
                                  height: 160,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(child: SizedBox(child: OneLoading.signup_done)),
                                      Center(
                                        child: Text(
                                          'Đăng ký thành công!',
                                          style: OneTheme.of(context).title1.copyWith(color: OneColors.blue200),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Chào mừng đến với Astronomy!\n${_nameController.text}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Đồng ý'),
                                  ),
                                ],
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: OneColors.red,
                                content: Text("Tài khoản đã tồn tại! Xin vui lòng đăng nhập"),
                              ),
                            );
                          } on PlatformException catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: OneColors.red,
                                content: Text("Email hoặc Password không hợp lệ! Hãy thử lại"),
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
                                'Đăng Ký',
                                style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Get.to(() => const LoginPage());
                    },
                    child: const Text("Đã có tài khoản? Đăng nhập"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
