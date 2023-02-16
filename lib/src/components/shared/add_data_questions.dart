// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/question_model.dart';

class AddQuestionsData extends StatelessWidget {
  const AddQuestionsData({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference questiondata = FirebaseFirestore.instance.collection('questiondata');

//  questionText: json['questionText'],
//     answersList: answersList,
//     tags: json['explanation'],
//     more: json['correctAnswer'],

//  answerText: json['answerText'],
//       isCorrect: json['isCorrect'],
    ///////////////////// DISCOVER DATA //////////////////////////
    Question question = Question(
      questionText: "Nhận định nào dưới đây chưa chính xác?",
      answersList: [
        Answer(answerText: "Các ngôi sao, hành tinh, vệ tinh được gọi chung là các thiên thể.", isCorrect: false),
        Answer(answerText: "Hệ Mặt Trời nằm trong Dải Ngân Hà.", isCorrect: false),
        Answer(answerText: "Dải Ngân Hà có phạm vi không gian lớn hơn Thiên Hà.", isCorrect: true),
        Answer(answerText: "Trong mỗi Thiên Hà có rất nhiều các hành tinh.", isCorrect: false),
      ],
      tags: "Đúng là vậy, Câu C sai vì Ngân Hà và Thiên Hà là một",
      more: "",
    );
    /////////////////////////////////////////////////////////////

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return questiondata
          .add({
            'questionText': question.questionText,
            'answersList': question.answersList
                .map((e) => {
                      'answerText': e.answerText,
                      'isCorrect': e.isCorrect,
                    })
                .toList(),
            'tags': question.tags,
            'more': question.more,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("Câu hỏi : ${question.questionText}"),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: question.answersList.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 50, width: 300, child: Text(question.answersList[index].answerText)),
                      Text(question.answersList[index].isCorrect.toString()),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text("Tags : ${question.tags}"),
            const SizedBox(height: 10),
            Text("More : ${question.more}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
