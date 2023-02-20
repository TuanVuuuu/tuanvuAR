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
    String name = "Sao Kim"; // Tên tiếng việt hành tinh có dấu // "Sao Mộc"

    ///ID NAME///
    String idName = "saokim"; // tags viết liền không dấu // "saomoc"
    //////IMAGE 2D///////
    Map colorGradient = {
      "bottom": "0xff8bc34a", // Màu gradient bottom
      "top": "0xff2196f3", // Màu gradient top
    };
    Map colors = {
      "colorGradient": colorGradient, // Màu gradient của card
      "colorModel": "0xFF9E5213", // Màu shadow của image2D
    };
    Map image2D = {
      "colors": colors, // Màu sắc
      // Link hình ảnh 2D
      "imageUrl": "https://firebasestorage.googleapis.com/v0/b/flutter-crud-33350.appspot.com/o/2D%20model%20Astronomy%2Fvenus-planet.png?alt=media&token=792cc533-52f8-4b0e-970f-190fad3e94ff",
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
        "Sao Kim hay Kim tinh, còn gọi là sao Thái Bạch, Thái Bạch Kim tinh là hành tinh thứ 2 trong hệ Mặt Trời, tự quay quanh nó với chu kỳ 224,7 ngày Trái Đất. Xếp sau Mặt Trăng, nó là thiên thể tự nhiên sáng nhất trong bầu trời tối, với cấp sao biểu kiến bằng −4.6, đủ sáng để tạo nên bóng trên mặt nước.";
    ////----//////
    /////INFO OTHER/////
    Map infoOther = {
      "acreage": "460.200.000 km", //Diện tích  km2
      "age": "4,503 Tỷ", // Tuổi
      "cycle": "225 ngày", // Chu kỳ quay
      "density": "5,24 g/cm", // Mật độ
      "distance": "108.200.000 km", // Khoảng cách
      "gravitation": "8,87 m/s", // trọng lực
      "radius": "6.051,8 km", // bán kính
      "satelliteNumber": "0", // sô lượng vệ tinh
      "temperature": "	462", // nhiệt độ
      "trajectory": "Mặt Trời", // quỹ đạo
    };
    ////////////////////
    //////VIDEO INTRO///
    String videosIntro = "https://www.gstatic.com/culturalinstitute/searchar/assets/venus_surface/desktop_dark.mp4";
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
