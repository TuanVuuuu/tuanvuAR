import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/loading/one_loading.dart';
import 'package:flutter_application_1/src/components/one_images.dart';
import 'package:flutter_application_1/ui/entryPoint/entry_point.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/more_button.dart';
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
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
  bool display = false;
  bool correct = false;
  final CollectionReference modeldata = FirebaseFirestore.instance.collection("modeldata");

  @override
  Widget build(BuildContext context) {
    String tagcheck = questionList[currentQuestionIndex].more;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(OneImages.bg3),
          fit: BoxFit.cover,
        ),
      ),
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
                            child: tagcheck != ""
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
                                          currentPlanets: tagcheck,
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
          height: MediaQuery.of(context).size.height * 0.15,
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Text(
            questionList[currentQuestionIndex].questionText,
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
      children: questionList[currentQuestionIndex]
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
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
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
            Text(answer.answerText),
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

              showDialog(context: context, builder: (_) => _showScoreDialog());
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
    String title = isPassed ? "Vượt qua " : "Thất Bại";

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "$title\nBạn đã dành được ${score * 10} điểm",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isPassed ? OneLoading.quiz_pass : OneLoading.quiz_false,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Chơi lại"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentQuestionIndex = 0;
                      score = 0;
                      selectedAnswer = null;
                    });
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Thoát"),
                  onPressed: () {
                    Get.to(() => const EntryPoint(), curve: Curves.linear, transition: Transition.rightToLeft);
                    setState(() {
                      currentQuestionIndex = 0;
                      score = 0;
                      selectedAnswer = null;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
