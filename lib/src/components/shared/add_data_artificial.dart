// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class AddArtificialData extends StatelessWidget {
  const AddArtificialData({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference artificialdata = FirebaseFirestore.instance.collection('artificialdata');

    ///////////////////// DISCOVER DATA //////////////////////////
    String name = "NASA Curiosity"; // Tên vệ tinh / sao chổi
    String idnew = "curiosity";
    List idname = ["Nhân tạo", "Sao Hoả"]; // Tags có dấu
    List tags = ["vetinh", "saohoa"]; // Tags viết liền không dấu
    // Thông tin của vệ tinh / sao chổi
    String info =
        "Curiosity là một chiếc xe tự hành có kích thước bằng một chiếc ô tô được thiết kế để khám phá miệng núi lửa Gale trên sao Hỏa như một phần của sứ mệnh Phòng thí nghiệm Khoa học sao Hỏa của NASA.";
    // Thông tin khác
    Map otherInfo = {
      "launch_date": "26 tháng 11, 2011", // Ngày phóng
      "speed": "0,14 km/h", // Tốc độ tối đa:
      "orbital_altitude": "", // Độ cao quỹ đạo:
      "speed_in_orbit": "", // Tốc độ trên quỹ đạo:
      "launch_location": "", //Địa điểm phóng:
      "manufacturer": "Boeing, Lockheed Martin", // Nhà sản xuất:
    };
    // Ảnh
    Map images = {
      // Ảnh 2D
      "image2DUrl":
          "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fmars-exploration-rover.png?alt=media&token=f6546aec-0324-4a4c-8973-e4bcafafe369",
      // Ảnh 3D
      "image3DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/3D%20model%20Astronomy%2Ffobos1.glb?alt=media&token=0b3c6e42-9e06-48fe-a67b-f964718213a0",
      // Ảnh scan
      "imageScan2D":
          "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fmars-exploration-rover.png?alt=media&token=f6546aec-0324-4a4c-8973-e4bcafafe369",
      "imageScan3D": "https://studio.onirix.com/projects/68d3c48f4a6940a3bfea953f70ca4a3c/webar?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjE2MjI3LCJwcm9qZWN0SWQiOjQwNjEzLCJyb2xlIjozLCJpYXQiOjE2ODA1NDEyOTl9.bq9hAprwtqDocVrKTLFCDxpmlA1CwHXpcrJjhnfr4Lg",
    };
    /////////////////////////////////////////////////////////////

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return artificialdata
          .add({
            'idnew': idnew,
            'info': info,
            'name': name,
            'idname': idname,
            'tags': tags,
            'otherInfo': otherInfo,
            'images': images,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    var noInfo = const Text("Chưa có dữ liệu");

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            name != "" ? Text(name) : noInfo,
            SizedBox(
              height: 100,
              width: 100,
              child: images["image2DUrl"] != ""
                  ? Image.network(
                      images["image2DUrl"],
                      fit: BoxFit.cover,
                    )
                  : noInfo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: idname.isNotEmpty
                  ? idname.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e),
                      );
                    }).toList()
                  : [noInfo],
            ),
            info != "" ? Text(info) : noInfo,
            const SizedBox(
              height: 20,
            ),
            otherInfo.isNotEmpty
                ? Column(
                    children: [
                      otherInfo["launch_date"] != "" ? Text("launch_date: ${otherInfo["launch_date"]}") : noInfo,
                      otherInfo["speed"] != "" ? Text("speed: ${otherInfo["speed"]}") : noInfo,
                      otherInfo["orbital_altitude"] != "" ? Text("orbital_altitude: ${otherInfo["orbital_altitude"]}") : noInfo,
                      otherInfo["speed_in_orbit"] != "" ? Text("speed_in_orbit: ${otherInfo["speed_in_orbit"]}") : noInfo,
                      otherInfo["launch_location"] != "" ? Text("launch_location: ${otherInfo["launch_location"]}") : noInfo,
                      otherInfo["manufacturer"] != "" ? Text("manufacturer: ${otherInfo["manufacturer"]}") : noInfo,
                    ],
                  )
                : noInfo,
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: images["image3DUrl"] != ""
                  ? Text(
                      "image3DUrl : ${images["image3DUrl"]}",
                    )
                  : noInfo,
            ),
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
