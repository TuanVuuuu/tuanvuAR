// ignore_for_file: depend_on_referenced_packages, unused_import, avoid_print, unused_local_variable

part of '../../../../libary/one_libary.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      Get.offAllNamed(AppRoutes.LOGIN_MANAGER.name);
    } else {
      Get.offAllNamed(AppRoutes.ENTRY_POINT.name);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => const BottomNavigationBarWidget(),
      //   ),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 3000), () {
        checkLoginStatus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    int seconds = 10;
    return Stack(
      children: [
        SizedBox(height: sizeHeight, width: sizeWidth, child: const SplashWidget()),
        Scaffold(
            backgroundColor: OneColors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // title images
                _buildTitle(sizeHeight, sizeWidth),
                const Spacer(),
                _buildLoadAnimation(sizeHeight, sizeWidth, seconds),

                const Spacer(),
              ],
            )),
      ],
    );
  }

  Center _buildLoadAnimation(double sizeHeight, double sizeWidth, int seconds) {
    return Center(
      child: SizedBox(
        height: sizeHeight * 0.25, width: sizeWidth * 0.9, child: OneLoading.space_loading_larget,
        
      ),
    );
  }

  Center _buildTitle(double sizeHeight, double sizeWidth) {
    return Center(
      child: Container(
          margin: const EdgeInsets.only(top: 100),
          width: sizeWidth,
          child: Image.asset(
            OneImages.bg5,
            fit: BoxFit.fitWidth,
          )),
    );
  }
}
