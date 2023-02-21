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
    String name = "Mimas"; // Tên vệ tinh / sao chổi
    String idnew = "mimas"; //tags tên của vệ tinh
    List idname = ["Vệ tinh tự nhiên", "Sao Thổ"]; // Tags có dấu
    List tags = ["vetinh", "saotho"]; // Tags viết liền không dấu
    // Thông tin của vệ tinh / sao chổi
    String info =
        "Mimas được William Herschel phát hiện năm 1789, là vệ tinh lớn thứ 7 Sao Thổ. Mimas còn có tên gọi khác là Saturn I. Mimas là thiên thể nhỏ nhất trong hệ Mặt Trời có hình cầu. Về đường kính, Mimas là vệ tinh lớn thứ 20 trong các vệ tinh của hệ Mặt Trời.";
    // Thông tin khác
    Map otherInfo = {
      "age": "", // Tuổi
      "cycle": "23 giờ", // Chu kỳ quay
      "density": "1,15 g/cm", // Mật độ
      "gravitation": "0,064 m/s", // Trọng Lực
      "radius": "198,2 km", // Bán kính
      "trajectory": "Sao Thổ", // Quỹ Đạo
    };
    // Ảnh
    Map images = {
      // Ảnh 2D
      "image2DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2FMimas.png?alt=media&token=2f96e194-4ef0-48a7-a7c3-f374d0344fa7",
      // Ảnh 3D
      "image3DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/3D%20model%20Astronomy%2Ffobos1.glb?alt=media&token=0b3c6e42-9e06-48fe-a67b-f964718213a0",
    };
    /////////////////////////////////////////////////////////////

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return discoverdata
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
