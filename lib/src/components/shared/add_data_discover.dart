// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDiscoverData extends StatelessWidget {
  const AddDiscoverData({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference discoverdata = FirebaseFirestore.instance.collection('discoverdata');

    ///////////////////// DISCOVER DATA //////////////////////////
    String name = "Callisto"; // Tên vệ tinh / sao chổi
    List idname = ["Vệ tinh tự nhiên", "Sao Mộc"]; // Tags có dấu
    List tags = ["vetinh", "saomoc"]; // Tags viết liền không dấu
    // Thông tin của vệ tinh / sao chổi
    String info =
        "Callisto là vệ tinh lớn thứ hai của Sao Mộc. Trong hệ Mặt Trời, Callisto là vệ tinh lớn thứ ba, sau Ganymede cũng của Sao Mộc và vệ tinh Titan của Sao Thổ. Callisto cũng là vật thể lớn thứ 12 trong Hệ Mặt Trời về đường kính. Vệ tinh được Galileo Galilei phát hiện vào năm 1610.";
    // Thông tin khác
    Map otherInfo = {
      "age": "4,503 Tỷ", // Tuổi
      "cycle": "17 ngày", // Chu kỳ quay
      "density": "1,83 g/cm", // Mật độ
      "gravitation": "1,236 m/s", // Trọng Lực
      "radius": "2.410,3 km", // Bán kính
      "trajectory": "Sao Mộc", // Quỹ Đạo
    };
    // Ảnh
    Map images = {
      // Ảnh 2D
      "image2DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fcallisto-jupiter.png?alt=media&token=1abd43e6-8740-4746-a2d5-b62dd91164ce",
      // Ảnh 3D
      "image3DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/3D%20model%20Astronomy%2Ffobos1.glb?alt=media&token=0b3c6e42-9e06-48fe-a67b-f964718213a0",
    };
    /////////////////////////////////////////////////////////////

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return discoverdata
          .add({
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
                      otherInfo["age"] != "" ? Text("age: ${otherInfo["age"]}") : noInfo,
                      otherInfo["cycle"] != "" ? Text("cycle: ${otherInfo["cycle"]}") : noInfo,
                      otherInfo["density"] != "" ? Text("density: ${otherInfo["density"]}") : noInfo,
                      otherInfo["gravitation"] != "" ? Text("gravitation: ${otherInfo["gravitation"]}") : noInfo,
                      otherInfo["radius"] != "" ? Text("radius: ${otherInfo["radius"]}") : noInfo,
                      otherInfo["trajectory"] != "" ? Text("trajectory: ${otherInfo["trajectory"]}") : noInfo,
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
