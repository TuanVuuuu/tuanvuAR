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
    String name = "Soyuz"; // Tên vệ tinh / sao chổi
    List idname = ["Vệ tinh nhân tạo", "Trái Đất"]; // Tags có dấu
    List tags = ["vetinh", "traidat"]; // Tags viết liền không dấu
    // Thông tin của vệ tinh / sao chổi
    String info =
        "Soyuz là chương trình chở người lên vũ trụ kéo dài nhất lịch sử. Tàu Soyuz đầu tiên phóng vào năm 1967. Kể từ đó, Nga đã phát triển 10 phiên bản khác nhau của mẫu tàu này. Hơn 150 chuyến bay chở người đã được thực hiện bởi tàu Soyuz. Soyuz có nghĩa là 'đoàn kết' trong tiếng Nga. Mọi phiên bản đều tuân theo thiết kế ba phần gồm module hạ cánh, module quỹ đạo và module đẩy. Trong lần phóng Soyuz đầu tiên, phi hành gia Vladimir Komarov thiệt mạng do sự cố của chiếc dù khi trở về Trái Đất.";
    // Thông tin khác
    Map otherInfo = {
      "launch_date": "23 tháng 4 năm 1967", // Ngày phóng
      "speed": "", // Tốc độ tối đa:
      "orbital_altitude": "197.0km", // Độ cao quỹ đạo:
      "speed_in_orbit": "", // Tốc độ trên quỹ đạo:
      "launch_location": "Sân bay Baikonur", //Địa điểm phóng:
      "manufacturer": "Liên bang Xô viết", // Nhà sản xuất:
    };
    // Ảnh
    Map images = {
      // Ảnh 2D
      "image2DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fsoyuz-1-satellite.png?alt=media&token=d59879df-a5e8-4fc7-8beb-1b4edf0df6cf",
      // Ảnh 3D
      "image3DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/3D%20model%20Astronomy%2Ffobos1.glb?alt=media&token=0b3c6e42-9e06-48fe-a67b-f964718213a0",
    };
    /////////////////////////////////////////////////////////////

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return artificialdata
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
