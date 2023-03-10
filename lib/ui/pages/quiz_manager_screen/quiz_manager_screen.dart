// ignore_for_file: must_be_immutable, unused_element
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/ui/pages/auth_screen/sign_out.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/quiz_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class QuizManagerScreen extends StatelessWidget {
  QuizManagerScreen({super.key});

  String tagsButton = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    double sizeHeight = MediaQuery.of(context).size.height;
    return AppScaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(OneImages.bg3),
          fit: BoxFit.cover,
        ),
      ),
      child: Scrollbar(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          _buildHeader(context),
          _buildBody(context, sizeHeight),
        ],
      )),
    ));
  }

  SliverToBoxAdapter _buildBody(BuildContext context, double sizeHeight) {
    return SliverToBoxAdapter(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: OneColors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleQuestion(context),
          Stack(
            children: [
              Container(
                height: sizeHeight * 0.3,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: OneColors.black.withOpacity(0.7),
                  border: Border.all(
                    color: OneColors.blue200,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              _buildCardTitle(sizeHeight, context),
              Padding(
                padding: EdgeInsets.only(top: sizeHeight * 0.21, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "M??n : Thi??n v??n h???c",
                      style: OneTheme.of(context).title2.copyWith(
                            color: OneColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Ch??? ????? : C??c H??nh tinh trong H??? M???t Tr???i",
                      style: OneTheme.of(context).title2.copyWith(
                            color: OneColors.white,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "T???ng c??u h???i : 10",
                            style: OneTheme.of(context).title2.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Gi???i thi???u t???ng quan",
                            style: OneTheme.of(context).title2.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [_buildButtonStart(context)],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Trong tr?? ch??i n??y, ng?????i ch??i s??? ph???i tr??? l???i c??c c??u h???i li??n quan ?????n thi??n v??n h???c. N?? bao g???m c??c c??u h???i v??? c??c h??nh tinh, ng??i sao, thi??n th??? v?? hi???n t?????ng thi??n v??n, c??ng nh?? c??c kh??i ni???m v?? thu???t ng??? li??n quan ?????n thi??n v??n h???c.",
                  textAlign: TextAlign.justify,
                  style: OneTheme.of(context).title2.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                /////////////////////////////////ADD DATA///////////////////////////////////
                //_addData(),
                /////////////////////////////////ADD DATA///////////////////////////////////
              ],
            ),
          )
        ],
      ),
    ));
  }

  Center _addData() {
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
            backgroundColor: OneColors.textOrange,
          ),
          onPressed: () {
            Get.to(() => SignOutScreen()
                //const AddNewsData(),
                //const AddArtificialData()
                //const AddQuestionsData(),
                );
          },
          child: const Text("Add data question")),
    );
  }

  Column _buildCardTitle(double sizeHeight, BuildContext context) {
    return Column(
      children: [
        Container(
          height: sizeHeight * 0.2,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: OneColors.blue200,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 1,
              child: Text(
                "C??c H??nh tinh trong h??? M???t Tr???i",
                style: OneTheme.of(context).header.copyWith(color: OneColors.white),
              ),
            ),
            Expanded(flex: 1, child: SvgPicture.asset(OneImages.questions_undraw)),
          ]),
        ),
      ],
    );
  }

  Padding _buildTitleQuestion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(
        "Ki???m tra s??? hi???u bi???t c???a b???n v??? v?? tr??? th??ng qua m???t s??? c??u h???i!",
        style: OneTheme.of(context).title1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.13,
      leading: const SizedBox(),
      floating: false,
      pinned: true,
      backgroundColor: OneColors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: 20, right: 20, bottom: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: OneColors.white,),
              ),
              Text("????? vui c??ng Astronomy", style: OneTheme.of(context).title1.copyWith(fontSize: 25, color: OneColors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonStart(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: OneColors.blue200,
        ),
        onPressed: () {
          Get.to(() => const QuizScreen());
        },
        child: const Text("B???t ?????u"));
  }
}

// ElevatedButton(
//     onPressed: () {
//       Get.to(() => const AddDiscoverData());
//     },
//     child: const Text("Add data discover")),
// ElevatedButton(
//     onPressed: () {
//       Get.to(() => const AddPlanetsData());
//     },
//     child: const Text("Add data planets")),
// ElevatedButton(
//     onPressed: () {
//       Get.to(() => const AddArtificialData());
//     },
//     child: const Text("Add data Aritificial")),
