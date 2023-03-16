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
        body: Scrollbar(
            child: CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        _buildHeader(context),
        _buildBody(context, sizeHeight),
      ],
    )));
  }

  SliverToBoxAdapter _buildBody(BuildContext context, double sizeHeight) {
    return SliverToBoxAdapter(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: OneColors.white,
        boxShadow: const [
          BoxShadow(
            color: OneColors.grey,
            blurRadius: 4,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleQuestion(context),
          Stack(
            children: [
              _buildCardBackGround(sizeHeight),
              _buildCardTitle(sizeHeight, context),
              _buildCardObject(sizeHeight, context),
            ],
          ),
          _buildCardInfo(context),
        ],
      ),
    ));
  }

  Container _buildCardInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng câu hỏi : 10",
                    style: OneTheme.of(context).title2.copyWith(color: OneColors.black, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Giới thiệu tổng quan",
                    style: OneTheme.of(context).title2.copyWith(color: OneColors.black, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [_buildButtonStart(context)],
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Trong trò chơi này, người chơi sẽ phải trả lời các câu hỏi liên quan đến thiên văn học. Nó bao gồm các câu hỏi về các hành tinh, ngôi sao, thiên thể và hiện tượng thiên văn, cũng như các khái niệm và thuật ngữ liên quan đến thiên văn học.",
            textAlign: TextAlign.justify,
            style: OneTheme.of(context).title2.copyWith(color: OneColors.black, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          /////////////////////////////////ADD DATA///////////////////////////////////
          //_addData(),
          /////////////////////////////////ADD DATA///////////////////////////////////
        ],
      ),
    );
  }

  Container _buildCardBackGround(double sizeHeight) {
    return Container(
      height: sizeHeight * 0.3,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: OneColors.black.withOpacity(0.7),
        border: Border.all(
          color: OneColors.blue200,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }

  Padding _buildCardObject(double sizeHeight, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: sizeHeight * 0.21, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Môn : Thiên văn học",
            style: OneTheme.of(context).title2.copyWith(
                  color: OneColors.white,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "Chủ đề : Các Hành tinh trong Hệ Mặt Trời",
            style: OneTheme.of(context).title2.copyWith(
                  color: OneColors.white,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
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
                "Các Hành tinh trong hệ Mặt Trời",
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "Kiểm tra sự hiểu biết của bạn về vũ trụ",
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: OneTheme.of(context).title1.copyWith(color: OneColors.black, fontWeight: FontWeight.w400),
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
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
          child: Text(
            "Đố vui",
            style: OneTheme.of(context).title1.copyWith(
                  fontSize: 25,
                  color: OneColors.black,
                ),
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
        child: const Text("Bắt đầu"));
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
