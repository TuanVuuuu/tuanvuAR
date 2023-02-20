// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/ui/entryPoint/entry_point.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/more_button.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/percentage_circle.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/question_model.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  //define the datas
  List<Question> questionList = [];
  bool isLoading = true;
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
  bool display = false;
  bool correct = false;
  final CollectionReference modeldata = FirebaseFirestore.instance.collection("modeldata");

  @override
  void initState() {
    super.initState();
    // getQuestionsData().then((value) {
    //   setState(() {
    //     questionList = value;
    //     print(value);
    //   });
    // });
    getData();
  }

  void getData() async {
    final snapshot = await FirebaseFirestore.instance.collection('questiondata').get();
    var random = Random();
    final data = snapshot.docs.map((doc) => doc.data());
    setState(() {
      isLoading = false;
      questionList = data.map((question) => Question.fromJson(question)).toList();
    });
    questionList.shuffle(random);
    questionList = questionList.sublist(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            decoration: OneWidget.background_bg3,
            child: Scaffold(
              backgroundColor: OneColors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OneLoading.space_loading_larget,
                    Text(
                      "Đang tải dữ liệu ...",
                      style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container(
            decoration: OneWidget.background_bg3,
            child: AppScaffold(
              appBar: AppBar(
                backgroundColor: OneColors.transparent,
                elevation: 0,
                title: const Text(
                  "Đố vui",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
              ),
              extendBodyBehindAppBar: true,
              backgroundColor: OneColors.transparent,
              body: Scrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(right: 16, left: 16, bottom: 32, top: 130),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: OneColors.black.withOpacity(0.7),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          _questionWidget(),
                          _answerList(),
                          display != false
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: correct != false
                                        ? Text(
                                            "Chính xác",
                                            style: OneTheme.of(context).body1.copyWith(color: OneColors.borderGreen),
                                          )
                                        : Text(
                                            "Sai rồi",
                                            style: OneTheme.of(context).body1.copyWith(color: OneColors.red),
                                          ),
                                  ),
                                )
                              : const SizedBox(),
                          display != false
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: questionList[currentQuestionIndex].more != ""
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: _buildReadMore(context),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: MoreButton(
                                                data: modeldata,
                                                currentPlanets: questionList[currentQuestionIndex].more,
                                              ),
                                            ),
                                          ],
                                        )
                                      : _buildReadMore(context))
                              : const SizedBox(
                                  height: 30,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _nextButton(),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Padding _buildReadMore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ReadMoreText(
        questionList[currentQuestionIndex].tags,
        style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
        trimLines: 4,
        textAlign: TextAlign.justify,
        trimMode: TrimMode.Line,
        trimCollapsedText: " Xem thêm",
        trimExpandedText: " ...Rút gọn",
        lessStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
        moreStyle: OneTheme.of(context).body1.copyWith(color: OneColors.yellow),
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textTitle("Câu hỏi ${currentQuestionIndex + 1}/${questionList.length.toString()}"),
            _textTitle("Điểm số   ${score * 10}/${(questionList.length * 10).toString()}"),
          ],
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          width: double.infinity,
          child: Text(
            questionList.isEmpty ? "" : questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Text _textTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  _answerList() {
    List title = ["A, ", "B, ", "C, ", "D, ", "E, ", "F, "];
    int i = 0;
    return Column(
      children: questionList.isEmpty
          ? [const SizedBox()]
          : questionList[currentQuestionIndex]
              .answersList
              .map(
                (e) => _answerButton(e, title[i++]),
              )
              .toList(),
    );
  }

  Widget _answerButton(Answer answer, String titleIndex) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? OneColors.white : OneColors.black,
          shape: const StadiumBorder(),
          backgroundColor: (isSelected ? (answer.isCorrect != false ? OneColors.borderGreen : OneColors.red) : OneColors.white),
        ),
        onPressed: () {
          if (selectedAnswer == null) {
            if (answer.isCorrect) {
              score++;
            }
            setState(() {
              selectedAnswer = answer;
              display = true;
              if (answer.isCorrect) {
                correct = true;
              }
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(titleIndex),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                answer.answerText,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: OneColors.textOrange,
          ),
          onPressed: () {
            if (isLastQuestion) {
              //display score

              // showDialog(context: context, builder: (_) => _showScoreDialog());
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: OneColors.transparent,
                elevation: 0,
                context: context,
                builder: (BuildContext context) => _showScoreDialog(),
              );
            } else {
              //next question
              setState(() {
                selectedAnswer = null;
                currentQuestionIndex++;
                display = false;
                correct = false;
              });
            }
          },
          child: Text(isLastQuestion ? "Xong" : "Tiếp theo"),
        ),
      ),
    );
  }

  _showScoreDialog() {
    bool isPassed = false;

    if (score >= questionList.length * 0.6) {
      //pass if 60 %
      isPassed = true;
    }
    String title = isPassed ? "Chúc mừng bạn!!" : "Rất tiếc";

    return Scaffold(
      backgroundColor: OneColors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: OneColors.buttonGrey,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 10,
                        width: 100,
                        decoration: BoxDecoration(color: OneColors.black12, borderRadius: BorderRadius.circular(20), boxShadow: const [
                          BoxShadow(
                            color: OneColors.white,
                            blurRadius: 0.2,
                          )
                        ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      isPassed ? "Hoàn thành" : "Kết thúc",
                      style: OneTheme.of(context).header.copyWith(color: isPassed ? OneColors.borderGreen : OneColors.red, fontSize: 30),
                    ),
                  ),
                  isPassed ? SizedBox(height: MediaQuery.of(context).size.height * 0.15, child: OneLoading.quiz_pass) : OneLoading.quiz_false,
                  Padding(
                    padding: const EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(color: OneColors.black12, borderRadius: BorderRadius.circular(20), boxShadow: const [
                        BoxShadow(
                          color: OneColors.white,
                          blurRadius: 1,
                        )
                      ]),
                      padding: const EdgeInsets.all(10),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top : 8.0),
                                child: SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${score * 10} / ${questionList.length * 10}",
                                          style: OneTheme.of(context).header.copyWith(color: OneColors.white),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "ĐIỂM",
                                          style: OneTheme.of(context).title2.copyWith(color: OneColors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              PercentageCircle(
                                percentage: (score / (questionList.length)) - 0.03,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: title,
                                        style: OneTheme.of(context).title1.copyWith(
                                              color: isPassed ? OneColors.borderGreen : OneColors.red,
                                            )),
                                    TextSpan(
                                        text: isPassed ? "\nBạn đã vượt qua bài kiểm tra với tỷ lệ " : "\nBạn đã không thể vượt qua bài kiểm tra với tỷ lệ ",
                                        style: OneTheme.of(context).title1.copyWith(
                                              color: OneColors.white,
                                            )),
                                    TextSpan(
                                        text: "${((score / questionList.length) * 100).truncate()}%.",
                                        style: OneTheme.of(context).title1.copyWith(
                                              color: isPassed ? OneColors.textOrange : OneColors.red,
                                            )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCheckAnswerCouter("Câu trả lời đúng", OneColors.borderGreen, score.toString()),
                        const SizedBox(width: 20),
                        _buildCheckAnswerCouter("Câu trả lời sai", OneColors.pink, "${questionList.length - score}"),
                      ],
                    ),
                  ),
                  _buildButtonPlayAgain(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const BottomNavigationBarWidget(), curve: Curves.linear, transition: Transition.rightToLeft);
                        setState(() {
                          currentQuestionIndex = 0;
                          score = 0;
                          selectedAnswer = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: OneColors.black12, borderRadius: BorderRadius.circular(15), boxShadow: const [
                          BoxShadow(
                            color: OneColors.white,
                            blurRadius: 3,
                          )
                        ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.home,
                                  color: OneColors.white,
                                  size: 30,
                                ),
                                Text(
                                  "Trở về trang chủ!",
                                  style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                                )
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(color: OneColors.textOrange, borderRadius: BorderRadius.circular(15), boxShadow: const [
                                BoxShadow(color: OneColors.white, blurRadius: 3),
                              ]),
                              child: Center(
                                child: Text(
                                  "Đi!",
                                  style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // AlertDialog(
    //   backgroundColor: OneColors.white,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   title: Text(
    //     "$title\nBạn đã dành được ${score * 10} điểm",
    //     style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
    //     textAlign: TextAlign.center,
    //   ),
    //   content: SizedBox(
    //     height: MediaQuery.of(context).size.height * 0.4,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         isPassed ? OneLoading.quiz_pass : OneLoading.quiz_false,
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //               ),
    //               child: const Text("Chơi lại"),
    //               onPressed: () {
    //                 Navigator.pop(context);
    //                 setState(() {
    //                   currentQuestionIndex = 0;
    //                   score = 0;
    //                   selectedAnswer = null;
    //                 });
    //               },
    //             ),
    //             const SizedBox(
    //               width: 15,
    //             ),
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //               ),
    //               child: const Text("Thoát"),
    //               onPressed: () {
    //                 Get.to(() => const EntryPoint(), curve: Curves.linear, transition: Transition.rightToLeft);
    //                 setState(() {
    //                   currentQuestionIndex = 0;
    //                   score = 0;
    //                   selectedAnswer = null;
    //                 });
    //               },
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Padding _buildButtonPlayAgain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentQuestionIndex = 0;
            score = 0;
            selectedAnswer = null;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: OneColors.textOrange, borderRadius: BorderRadius.circular(15), boxShadow: const [
            BoxShadow(
              color: OneColors.black,
              blurRadius: 5,
            )
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.autorenew,
                color: OneColors.white,
                size: 30,
              ),
              Text(
                "Chơi lại nào!",
                style: OneTheme.of(context).title1.copyWith(color: OneColors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildCheckAnswerCouter(String title, Color color, String score) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15), boxShadow: const [
          BoxShadow(
            color: OneColors.black,
            blurRadius: 5,
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(score, style: OneTheme.of(context).header.copyWith(color: OneColors.white)),
              Text(title, style: OneTheme.of(context).title2.copyWith(color: OneColors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
