part of '../../../libary/one_libary.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
