// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSendingEmail = false;
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quên Mật Khẩu",
          style: OneTheme.of(context).header.copyWith(color: OneColors.black),
        ),
        centerTitle: true,
        backgroundColor: OneColors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: OneColors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                  child: Text(
                    "Nhập lại email của bạn để xác nhận!",
                    style: OneTheme.of(context).header.copyWith(color: OneColors.black),
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Email : example@gmail.com",
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
              InkWell(
                onTap: _isSendingEmail ? null : _resetPassword,
                child: _isSendingEmail
                    ? OneLoading.space_loading
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(image: AssetImage(OneImages.bg4), fit: BoxFit.fitWidth),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'Đặt lại mật khẩu',
                              style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                            ),
                          ),
                        )),
              ),
              if (_isEmailSent)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Một địa chỉ xác nhận đặt lại mật khẩu đã được gửi đến email của bạn!'
                    ' Vui lòng kiểm tra thư mục email để đặt lại mật khẩu',
                    style: TextStyle(color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingEmail = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
        setState(() {
          _isEmailSent = true;
        });
      } catch (e) {
        print('Failed to send reset email: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Đã có lỗi xảy ra! Vui lòng thử lại'),
          ),
        );
      } finally {
        setState(() {
          _isSendingEmail = false;
        });
      }
    }
  }
}
