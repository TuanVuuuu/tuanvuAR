// ignore_for_file: unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getDiscoverData() async {
  CollectionReference discoverdata = FirebaseFirestore.instance.collection("discoverdata");
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
    print(mapData);
  }
  return dataList;
}
