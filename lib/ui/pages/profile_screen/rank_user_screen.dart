import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/components/one_images.dart';

class RankUserScreen extends StatefulWidget {
  const RankUserScreen({super.key, required this.usersdataDataList});

  final List usersdataDataList;

  @override
  State<RankUserScreen> createState() => _RankUserScreenState();
}

class _RankUserScreenState extends State<RankUserScreen> {
  List<Map<String, dynamic>> _leaderboard = [];

  Map<String, dynamic>? _mapCurrentUser;
  String nameUserCurrent = "";
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
    _loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(OneImages.bg4),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: OneColors.transparent,
        body: Stack(
          children: [
            _buildButtonBack(context),
            _buildTopThree(sizeWidth, context),
            _buildListRankUsers(sizeHeight, sizeWidth),
            _buildCurrentInfo(sizeWidth, context),
          ],
        ),
      ),
    );
  }

  Align _buildCurrentInfo(double sizeWidth, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        width: sizeWidth,
        decoration:
            const BoxDecoration(color: OneColors.white, boxShadow: [BoxShadow(color: OneColors.grey, blurRadius: 4)], image: DecorationImage(image: AssetImage(OneImages.bg4), fit: BoxFit.fitWidth)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              _mapCurrentUser != null ? "#${_mapCurrentUser?["rank"] + 1}" : "#",
              style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP),
            ),
            Text(
              _mapCurrentUser != null ? "${_mapCurrentUser?["name"]}" : "Người chơi",
              style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP),
            ),
            Text(
              _mapCurrentUser != null ? "${_mapCurrentUser?["scores"]}" : "0",
              style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTopThree(double sizeWidth, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70 + 55),
      width: sizeWidth,
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTopThreeRanker(
            context,
            sizeWidth,
            _leaderboard.isNotEmpty ? '${_leaderboard[1]['name']}' : "Rank 1",
            _leaderboard.isNotEmpty ? '${_leaderboard[1]['scores']}' : "0",
            OneImages.icons_rank_no2,
            125,
            OneColors.grey,
          ),
          _buildTopThreeRanker(
            context,
            sizeWidth,
            _leaderboard.isNotEmpty ? '${_leaderboard[0]['name']}' : "Rank 1",
            _leaderboard.isNotEmpty ? '${_leaderboard[0]['scores']}' : "0",
            OneImages.icons_rank_no1,
            150,
            OneColors.amber,
          ),
          _buildTopThreeRanker(
            context,
            sizeWidth,
            _leaderboard.isNotEmpty ? '${_leaderboard[3]['name']}' : "Rank 1",
            _leaderboard.isNotEmpty ? '${_leaderboard[3]['scores']}' : "0",
            OneImages.icons_rank_no3,
            100,
            OneColors.textOrange,
          ),
        ],
      ),
    );
  }

  Align _buildTopThreeRanker(BuildContext context, double sizeWidth, String name, String scores, String image, double height, Color color) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _leaderboard.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
                    ),
                    Container(
                      height: 30,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [
                        BoxShadow(
                          color: OneColors.grey,
                          blurRadius: 4,
                        )
                      ]),
                      child: Text(
                        scores,
                        style: OneTheme.of(context).body1.copyWith(color: OneColors.brandVNP),
                      ),
                    )
                  ],
                )
              : const Text('#2'),
          Container(
            height: height,
            width: sizeWidth * 0.25,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  child: Image.asset(
                    image,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRankUsers(double sizeHeight, double sizeWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 70 + 55 + 10 + 240, bottom: 50),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: OneColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Bảng xếp hạng',
                style: OneTheme.of(context).body1.copyWith(color: OneColors.black, fontSize: 20),
              ),
            ),
            SizedBox(
              height: sizeHeight - (70 + 55 + 20 + 262 + 50),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.zero,
                itemCount: _leaderboard.length,
                itemBuilder: (context, index) {
                  final String name = _leaderboard[index]['name'];
                  final int score = _leaderboard[index]['scores'];

                  return Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 15),
                    width: sizeWidth - 20,
                    decoration: BoxDecoration(
                      color: index + 1 == 3
                          ? const Color.fromARGB(255, 255, 221, 120)
                          : index + 1 == 2
                              ? const Color.fromARGB(255, 255, 148, 155)
                              : index + 1 == 1
                                  ? const Color.fromARGB(255, 133, 190, 243)
                                  : OneColors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: OneColors.grey,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '#${index + 1}',
                                style: OneTheme.of(context).body1.copyWith(color: OneColors.black),
                              ),
                              SizedBox(
                                height: 20,
                                child: index + 1 == 1
                                    ? Image.asset(OneImages.icons_rank_no1)
                                    : (index + 1 == 2 ? Image.asset(OneImages.icons_rank_no2) : (index + 1 == 3 ? Image.asset(OneImages.icons_rank_no3) : const SizedBox())),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                name,
                                style: OneTheme.of(context).body1.copyWith(color: OneColors.black),
                              ),
                            ],
                          ),
                          Text(
                            score.toString(),
                            style: OneTheme.of(context).body1.copyWith(color: OneColors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildButtonBack(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 24),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              color: OneColors.bgButton,
              boxShadow: const [
                BoxShadow(
                  color: OneColors.grey,
                  blurRadius: 4,
                ),
              ],
              border: Border.all(color: OneColors.white, width: 1),
              borderRadius: BorderRadius.circular(30)),
          child: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(Icons.arrow_back_ios, color: OneColors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _loadLeaderboard() async {
    final List<Map<String, dynamic>> leaderboard = await getLeaderboard();
    setState(() {
      _leaderboard = leaderboard;
    });
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    // Lấy danh sách người dùng theo thứ tự điểm số từ cao đến thấp
    final QuerySnapshot usersQuerySnapshot = await usersCollection.orderBy('scores', descending: true).get();
    // Tạo danh sách người dùng theo thứ tự điểm số
    List<Map<String, dynamic>> leaderboard = [];
    for (var userDocSnapshot in usersQuerySnapshot.docs) {
      final Map<String, dynamic> userData = {
        'name': userDocSnapshot.get('name'),
        'scores': userDocSnapshot.get('scores'),
        'email': userDocSnapshot.get('email'),
      };
      leaderboard.add(userData);
    }
    return leaderboard;
  }

  Future<void> _loadCurrentUser() async {
    final Map<String, dynamic> leaderboard = await getCurrentUser();
    setState(() {
      _mapCurrentUser = leaderboard;
    });
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    final QuerySnapshot usersQuerySnapshot = await usersCollection.orderBy('scores', descending: true).get();
    final userDocSnapshots = usersQuerySnapshot.docs;

    // Tìm vị trí của người dùng hiện tại trong danh sách
    final currentUserDocSnapshot = userDocSnapshots.firstWhere((docSnapshot) => docSnapshot.get('email') == currentUser?.email);
    final currentUserIndex = userDocSnapshots.indexOf(currentUserDocSnapshot);

    // Tạo một Map chứa thông tin người dùng và số thứ tự của họ
    final currentUserData = {
      'name': currentUserDocSnapshot.get('name'),
      'scores': currentUserDocSnapshot.get('scores'),
      'rank': currentUserIndex,
    };

    return currentUserData;
  }
}
