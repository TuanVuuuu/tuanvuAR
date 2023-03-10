// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/ui/pages/quiz_screen/question_model.dart';

Future<List<Map<String, dynamic>>> getDiscoverData() async {
  CollectionReference discoverdata = FirebaseFirestore.instance.collection("discoverdata");
  List<DocumentSnapshot> items = [];
  List<Map<String, dynamic>> dataList = [];
  QuerySnapshot snapshot = await discoverdata.get();
  for (var element in snapshot.docs) {
    var mapData = element.data() as Map<String, dynamic>;
    dataList.add(mapData);
    //print(mapData);
  }
  return dataList;
}

Future<List<Map<String, dynamic>>> getArtificialData() async {
  CollectionReference discoverdata = FirebaseFirestore.instance.collection("artificialdata");
  List<DocumentSnapshot> items = [];
  List<Map<String, dynamic>> dataList = [];
  QuerySnapshot snapshot = await discoverdata.get();
  for (var element in snapshot.docs) {
    var mapData = element.data() as Map<String, dynamic>;
    dataList.add(mapData);
    print(mapData);
  }
  return dataList;
}

Future<List<Map<String, dynamic>>> getHomeData() async {
  CollectionReference discoverdata = FirebaseFirestore.instance.collection("homedata");
  List<DocumentSnapshot> items = [];
  List<Map<String, dynamic>> dataList = [];
  QuerySnapshot snapshot = await discoverdata.get();
  for (var element in snapshot.docs) {
    var mapData = element.data() as Map<String, dynamic>;
    dataList.add(mapData);
    print(mapData);
  }
  return dataList;
}

Future<List<Map<String, dynamic>>> getPlanetsData() async {
  CollectionReference modeldata = FirebaseFirestore.instance.collection("modeldata");
  List<DocumentSnapshot> items = [];
  List<Map<String, dynamic>> dataList = [];
  QuerySnapshot snapshot = await modeldata.get();
  for (var element in snapshot.docs) {
    var mapData = element.data() as Map<String, dynamic>;
    dataList.add(mapData);
    // print(mapData);
  }
  return dataList;
}

Future<List<Question>> getQuestionsData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore.collection('questionData').get();
  return querySnapshot.docs.map((doc) => questionFromJson(json.encode(doc.data()))).toList();
}

Question questionFromJson(String jsonStr) {
  Map<String, dynamic> json = jsonDecode(jsonStr);
  List<Answer> answersList = List<Answer>.from(json['answersList'].map((answer) => Answer.fromJson(answer)));
  return Question(
    questionText: json['questionText'],
    answersList: answersList,
    tags: json['explanation'],
    more: json['correctAnswer'],
  );
}

Future<List<Map<String, dynamic>>> getUserData() async {
  CollectionReference usersdata = FirebaseFirestore.instance.collection("users");
  List<DocumentSnapshot> items = [];
  List<Map<String, dynamic>> dataList = [];
  QuerySnapshot snapshot = await usersdata.get();
  for (var element in snapshot.docs) {
    var mapData = element.data() as Map<String, dynamic>;
    dataList.add(mapData);
    //print(mapData);
  }
  return dataList;
}
