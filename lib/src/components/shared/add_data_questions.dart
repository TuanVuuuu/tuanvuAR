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
      questionText: "Với các hành tinh sau của hệ Mặt Trời: Kim tinh, Mộc tinh, Thủy tinh, Hỏa tinh, Trái Đất, Hải Vương tinh. Thứ tự các hành tinh xa dần Mặt Trời là:",
      answersList: [
        Answer(answerText: "Kim tinh, Mộc tinh, Thủy tinh, Hỏa tinh, Trái Đất, Hải Vương tinh. ", isCorrect: false),
        Answer(answerText: "Hỏa tinh, Kim tinh, Trái Đất, Mộc tinh, Thủy tinh, Hải Vương tinh. ", isCorrect: false),
        Answer(answerText: "Thủy tinh, Kim tinh, Trái Đất, Hỏa tinh, Mộc tinh, Hải Vương tinh. ", isCorrect: true),
        Answer(answerText: "Hải Vương tinh. Mộc tinh, Hỏa tinh, Trái Đất, Kim tinh,Thủy tinh.", isCorrect: false),
      ],
      tags: "Thứ tự các hành tinh xa dần Mặt Trời là Thủy tinh, Kim tinh, Trái Đất, Hỏa tinh, Mộc tinh, Hải Vương tinh.",
      more: "",  // saokim, traidat, saothuy, saomoc, saothuy, saotho
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
