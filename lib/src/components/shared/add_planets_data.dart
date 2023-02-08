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
    String name = "Sao Mộc"; // Tên tiếng việt hành tinh có dấu // "Sao Mộc"

    ///ID NAME///
    String idName = "saomoc"; // tags viết liền không dấu // "saomoc"
    //////IMAGE 2D///////
    Map colorGradient = {
      "bottom": "0xff3f51b5", // Màu gradient bottom
      "top": "0xff795548", // Màu gradient top
    };
    Map colors = {
      "colorGradient": colorGradient, // Màu gradient của card
      "colorModel": "0xFF78371C", // Màu shadow của image2D
    };
    Map image2D = {
      "colors": colors, // Màu sắc
      // Link hình ảnh 2D
      "imageUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fjupiter-planet.png?alt=media&token=4de02df2-cd3d-4757-a6b0-6b475552977a",
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
        "Sao Mộc hay Mộc tinh là hành tinh thứ năm tính từ Mặt Trời và là hành tinh lớn nhất trong Hệ Mặt Trời. Nó là hành tinh khí khổng lồ với khối lượng bằng một phần nghìn của Mặt Trời nhưng bằng hai lần rưỡi tổng khối lượng của tất cả các hành tinh khác trong Hệ Mặt Trời cộng lại.";
    ////----//////
    /////INFO OTHER/////
    Map infoOther = {
      "acreage": "6,1420 Tỷ km", //Diện tích
      "age": "4,603 Tỷ", // Tuổi
      "cycle": "11,8618 năm", // Chu kỳ quay
      "density": "1,326 g/cm", // Mật độ
      "distance": "778.500.000 km", // Khoảng cách
      "gravitation": "24,79 m/s", // trọng lực
      "radius": "69.911 km", // bán kính
      "satelliteNumber": "92", // sô lượng vệ tinh
      "temperature": "- 145", // nhiệt độ
      "trajectory": "Mặt Trời", // quỹ đạo
    };
    ////////////////////
    //////VIDEO INTRO///
    String videosIntro = "https://www.gstatic.com/culturalinstitute/searchar/assets/earth/desktop_dark.mp4";
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
