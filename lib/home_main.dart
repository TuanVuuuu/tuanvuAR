import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/pages/home_screen/home_screen.dart';
import 'package:flutter_application_1/ui/pages/news_screen/top_news_screen.dart';
import 'package:flutter_application_1/ui/pages/profile_screen/profile_screen.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final CollectionReference homedata = FirebaseFirestore.instance.collection("homedata");

  var _indexPages = 0;

  final pageOtions = [
    const HomeScreen(),
    const TopNewsScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOtions[_indexPages],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
        child: CurvedNavigationBar(
          backgroundColor: Colors.black,
          items: const <Widget>[
            Icon(Icons.home),
            Icon(Icons.book),
            Icon(Icons.person),
          ],
          onTap: ((int index) {
            setState(() {
              _indexPages = index;
            });
          }),
        ),
      ),
    );
  }
}
