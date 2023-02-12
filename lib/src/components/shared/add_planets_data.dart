// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlanetsData extends StatelessWidget {
  const AddPlanetsData({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference modeldata = FirebaseFirestore.instance.collection('modeldata');

    ///////////////////// DISCOVER DATA //////////////////////////
    ///NAME////
    String name = "Sao Thổ"; // Tên tiếng việt hành tinh có dấu // "Sao Mộc"

    ///ID NAME///
    String idName = "saotho"; // tags viết liền không dấu // "saomoc"
    //////IMAGE 2D///////
    Map colorGradient = {
      "bottom": "0xffe91e63", // Màu gradient bottom
      "top": "0xff607d8b", // Màu gradient top
    };
    Map colors = {
      "colorGradient": colorGradient, // Màu gradient của card
      "colorModel": "0xFFDBBC79", // Màu shadow của image2D
    };
    Map image2D = {
      "colors": colors, // Màu sắc
      // Link hình ảnh 2D
      "imageUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fsaturn-planet.png?alt=media&token=bae060de-cbdf-46ef-9071-2e9e486c7d63",
    };
    //////--------///////
    //////IMAGE 3D//////
    Map image3D = {
      "imageARUrl": "https://github.com/TuanVuuuu/tuanvu_assets/blob/02012023/assets/3d_images/planet_earth_1.glb?raw=true",
      "imageUrl": "https://cartmagician.com/arview/v1?asset=5858ff3c-b8a3-4a5d-b9be-ec21c293da88&ar=off",
    };
    /////---------//////
    /////INFO//////
    String info =
        "Sao Thổ tức Thổ tinh là hành tinh thứ sáu tính theo khoảng cách trung bình từ Mặt Trời và là hành tinh lớn thứ hai về đường kính cũng như khối lượng, sau Sao Mộc trong Hệ Mặt Trời. Tên tiếng Anh của hành tinh mang tên thần Saturn trong thần thoại La Mã, ký hiệu thiên văn của hành tinh là thể hiện cái liềm của thần.";
    ////----//////
    /////INFO OTHER/////
    Map infoOther = {
      "acreage": "4,270 Tỷ km", //Diện tích
      "age": "4,503 Tỷ", // Tuổi
      "cycle": "29,4571 năm", // Chu kỳ quay
      "density": "0,687 g/cm", // Mật độ
      "distance": "1,434 Tỷ km", // Khoảng cách
      "gravitation": "10,44 m/s", // trọng lực
      "radius": "58.232 km", // bán kính
      "satelliteNumber": "62", // sô lượng vệ tinh
      "temperature": "- 185", // nhiệt độ
      "trajectory": "Mặt Trời", // quỹ đạo
    };
    ////////////////////
    //////VIDEO INTRO///
    String videosIntro = "https://www.gstatic.com/culturalinstitute/searchar/assets/saturn/desktop_dark.mp4";
    /////////////////////////////////////////////////////////////

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return modeldata
          .add({
            'name': name,
            'idName': idName,
            'image2D': image2D,
            'image3D': image3D,
            'info': info,
            'infoOther': infoOther,
            'videosIntro': videosIntro,
          })
          .then((value) => print("Planets Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    var noInfo = const Text("Chưa có dữ liệu");

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            const SizedBox(
              height: 100,
            ),
            name != "" ? Text(name) : noInfo,
            idName != "" ? Text(idName) : noInfo,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(int.parse(colorGradient["bottom"])),
                        Color(int.parse(colorGradient["top"])),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(image2D["imageUrl"]),
                ),
              ],
            ),
            info != "" ? Text(info) : noInfo,
            const SizedBox(height: 20),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
