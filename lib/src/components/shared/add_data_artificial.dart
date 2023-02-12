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
    String name = "Sputnik 1"; // Tên vệ tinh / sao chổi
    List idname = ["Vệ tinh nhân tạo", "Trái Đất"]; // Tags có dấu
    List tags = ["vetinh", "traidat"]; // Tags viết liền không dấu
    // Thông tin của vệ tinh / sao chổi
    String info =
        "Sputnik 1 là vệ tinh Trái đất nhân tạo đầu tiên. Nó được Liên Xô phóng vào quỹ đạo hình elip thấp của Trái đất vào ngày 4 tháng 10 năm 1957 như một phần của chương trình không gian của Liên Xô.";
    // Thông tin khác
    Map otherInfo = {
      "launch_date": "4 tháng 10, 1957", // Ngày phóng
      "speed": "29.000 km/h", // Tốc độ tối đa: 
      "orbital_altitude": "577 km", // Độ cao quỹ đạo: 
      "speed_in_orbit": "8 km/s", // Tốc độ trên quỹ đạo:
      "launch_location": "Gagarin's Start", //Địa điểm phóng: 
      "manufacturer": "Tập đoàn Energia", // Nhà sản xuất: 
    };
    // Ảnh
    Map images = {
      // Ảnh 2D
      "image2DUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fsputnik-1-satellite.png?alt=media&token=1e50e410-a882-4446-a382-1f4bde35c407",
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
