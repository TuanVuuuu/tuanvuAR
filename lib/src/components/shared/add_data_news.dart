// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewsData extends StatelessWidget {
  const AddNewsData({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference homedata = FirebaseFirestore.instance.collection('homedata');

    ///////////////////// NEWS DATA //////////////////////////
    String author = "Mực Tím"; // Tên tác giả

    final DateTime now = DateTime.now();
    final Timestamp date = Timestamp.fromDate(now);

    ///
    String title = "Khám phá vũ trụ: Sao Kim - hành tinh nóng nhất trong hệ mặt trời"; //Tên tiêu đề
    // tên tiêu đề sẽ hiển thị ở bên ngoài
    String titleDisplay =
        "Sao Kim là hành tinh sáng nhất trong Hệ Mặt trời sau Mặt trăng và Mặt trời. Sao Kim được đặt theo tên vị thần tình yêu và sắc đẹp của La Mã - Venus. Lý do nó được đặt theo tên của vị thần đẹp nhất trong quần thể vì nó tỏa sáng nhất trong số 5 hành tinh mà các nhà thiên văn học cổ đại biết đến.";

    ///
    String guideTitle = "Sao Kim, hành tinh thứ hai gần Mặt trời, là một vì tinh tú có rất nhiều điều kỳ thú.";

    ////////////////// CONTENT List 1///////////////////////////////
    String caption = "";
    List<String> contents = [
      "Sao Kim là hành tinh sáng nhất trong Hệ Mặt trời sau Mặt trăng và Mặt trời. Sao Kim được đặt theo tên vị thần tình yêu và sắc đẹp của La Mã - Venus. Lý do nó được đặt theo tên của vị thần đẹp nhất trong quần thể vì nó tỏa sáng nhất trong số 5 hành tinh mà các nhà thiên văn học cổ đại biết đến.",
    ];
    String imageUrl = "http://static.muctim.com.vn/data/teen360/pictures/2022/04/11/1649647233_mai-h-m.jpg";
    String imageNotes = "Sao Kim còn được biết đến với tên gọi sao Hôm hoặc sao Mai.";
    String imageCredit = "";

    Map images = {
      "imageCredit": imageCredit,
      "imageNotes": imageNotes,
      "imageUrl": imageUrl,
    };
    List<String> contentsMore = [];

    String tagsContents = "saokim";
    Map contentDetail = {
      "caption": caption,
      "contents": contents,
      "contentsMore": contentsMore,
      "images": images,
      "tags": tagsContents,
    };

    /////////////////// CONTENT List 2//////////////////////////////
    String caption1 = "";
    List<String> contents1 = [
      "Sao Kim là một trong những vật thể sáng nhất trên bầu trời, do đó nó hay bị nhầm là vật thể bay không xác định (UFO). Vào thời cổ đại, sao Kim thường được cho là 2 ngôi sao khác nhau, ngôi sao buổi tối và ngôi sao buổi sáng. Nó là ngôi sao xuất hiện đầu tiên vào ban đêm và biến mất cuối cùng vào lúc bình minh. Trong tiếng Latinh, chúng lần lượt được gọi là Vesper và Lucifer.",
    ];
    String imageUrl1 = "http://static.muctim.com.vn/data/teen360/pictures/2022/04/11/1649646879_sao_kim_1_saiy.jpg";
    String imageNotes1 = "Vị trí của sao Kim trong hệ Mặt trời.";
    String imageCredit1 = "";

    List<String> contentsMore1 = [];

    Map images1 = {
      "imageCredit": imageCredit1,
      "imageNotes": imageNotes1,
      "imageUrl": imageUrl1,
    };

    String tagsContents1 = "";
    Map contentDetail1 = {
      "guideTitle": guideTitle,
      "caption": caption1,
      "contents": contents1,
      "contentsMore": contentsMore1,
      "images": images1,
      "tags": tagsContents1,
    };

    /////////////////////////////////////////////////////////////
    ////////////////////// CONTENT List 3//////////////////////////////
    String caption2 = "Kích thước của sao Kim";
    List<String> contents2 = [
      "Sao Kim và Trái đất thường được gọi là anh em sinh đôi vì chúng giống nhau về kích thước, khối lượng, mật độ, thành phần và lực hấp dẫn. Đường kính của sao Kim bằng 12.092km, chỉ nhỏ hơn 650km so với Trái Đất của chúng ta, và khối lượng bằng khoảng 80% Trái đất.",
    ];
    String imageUrl2 = "";
    String imageNotes2 = "";
    String imageCredit2 = "";

    List<String> contentsMore2 = [];

    Map images2 = {
      "imageCredit": imageCredit2,
      "imageNotes": imageNotes2,
      "imageUrl": imageUrl2,
    };

    String tagsContents2 = "";
    Map contentDetail2 = {
      "caption": caption2,
      "contents": contents2,
      "contentsMore": contentsMore2,
      "images": images2,
      "tags": tagsContents2,
    };

    /////////////////////////////////////////////////////////////
    ///////////////////////// CONTENT List 4//////////////////////////////
    String caption3 = "Cấu tạo sao Kim";
    List<String> contents3 = [
      "Bên trong của Sao Kim được làm bằng một lõi sắt kim loại rộng khoảng 6.000 km. Lớp phủ đá nóng chảy của sao Kim dày khoảng 3.000 km. Vỏ sao Kim chủ yếu là đá bazan và ước tính dày trung bình từ 10 đến 20 km.",
    ];
    String imageUrl3 = "http://static.muctim.com.vn/data/teen360/pictures/2022/04/11/1649646835_loi-sao-kim.jpg";
    String imageNotes3 = "";
    String imageCredit3 = "";

    List<String> contentsMore3 = [];

    Map images3 = {
      "imageCredit": imageCredit3,
      "imageNotes": imageNotes3,
      "imageUrl": imageUrl3,
    };

    String tagsContents3 = "";
    Map contentDetail3 = {
      "caption": caption3,
      "contents": contents3,
      "contentsMore": contentsMore3,
      "images": images3,
      "tags": tagsContents3,
    };

    /////////////////////////////////////////////////////////////
    //////////////////////////// CONTENT List 5//////////////////////////////
    String caption4 = "Nhiệt độ của sao Kim";
    List<String> contents4 = [
      "Sao Kim là hành tinh nóng nhất trong hệ mặt trời. Mặc dù sao Kim không phải là hành tinh gần mặt trời nhất, bầu khí quyển dày đặc của nó giữ nhiệt trong một phiên bản chạy trốn của hiệu ứng nhà kính làm Trái đất ấm lên. Kết quả là nhiệt độ trên sao Kim lên tới 880 độ F (471 độ C), đủ nóng để nấu chảy chì. Các tàu vũ trụ đã sống sót chỉ vài giờ sau khi hạ cánh xuống hành tinh này trước khi bị phá hủy.",
    ];
    String imageUrl4 = "http://static.muctim.com.vn/data/teen360/pictures/2022/04/11/1649647271_sao-kim-google-sites-15182253.jpg";
    String imageNotes4 = "";
    String imageCredit4 = "";

    List<String> contentsMore4 = [
      "Với nhiệt độ thiêu đốt, sao Kim có bầu khí quyển địa ngục, chủ yếu bao gồm carbon dioxide với các đám mây axit sunfuric và chỉ có một lượng nhỏ nước. Bầu khí quyển của nó nặng hơn bất kỳ hành tinh nào khác, dẫn đến áp suất bề mặt gấp 90 lần Trái đất - tương tự như áp suất tồn tại sâu 1000 mét trong đại dương.",
    ];

    Map images4 = {
      "imageCredit": imageCredit4,
      "imageNotes": imageNotes4,
      "imageUrl": imageUrl4,
    };

    String tagsContents4 = "";
    Map contentDetail4 = {
      "caption": caption4,
      "contents": contents4,
      "contentsMore": contentsMore4,
      "images": images4,
      "tags": tagsContents4,
    };

    /////////////////////////////////////////////////////////////
    //////////////////////////// CONTENT List 5//////////////////////////////
    String caption5 = "Sao Kim hoạt động như thế nào?";
    List<String> contents5 = [
      "Sao Kim mất 243 ngày Trái đất để quay trên trục của nó, đây là hành tinh chậm nhất trong số các hành tinh chính. Sao Kim quay một vòng quanh Mặt trời mất 225 ngày (so với Trái đất là 365 ngày).",
      "Nếu nhìn từ trên cao, sao Kim quay trên trục của nó theo hướng ngược lại với hầu hết các hành tinh. Sao Kim quay từ Đông sang Tây, trong khi tất cả các hành tinh khác đều quay theo hướng ngược lại (từ Tây sang Đông). Nói cách khác, ở sao Kim, Mặt Trời mọc ở hướng Tây và lặn ở hướng Đông.",
    ];
    String imageUrl5 = "";
    String imageNotes5 = "";
    String imageCredit5 = "";

    List<String> contentsMore5 = [];

    Map images5 = {
      "imageCredit": imageCredit5,
      "imageNotes": imageNotes5,
      "imageUrl": imageUrl5,
    };

    String tagsContents5 = "";
    Map contentDetail5 = {
      "caption": caption5,
      "contents": contents5,
      "contentsMore": contentsMore5,
      "images": images5,
      "tags": tagsContents5,
    };

    /////////////////////////////////////////////////////////////
    //////////////////////////// CONTENT List 6//////////////////////////////
    String caption6 = "Khí hậu sao Kim";
    List<String> contents6 = [
      "Lớp trên cùng của các đám mây của sao Kim được đẩy bởi sức gió bão với tốc độ di chuyển khoảng 360 km/h. Bầu khí quyển dày đặc tạo ra hiện tượng hiệu ứng nhà kính làm cho hành tinh này trở nên cực nóng.",
      "Tàu vũ trụ Venus Express hoạt động từ năm 2005 đến năm 2014, đã tìm thấy bằng chứng về tia sét trên hành tinh, hình thành trong các đám mây axit sunfuric. Nó có khả năng phóng điện từ sét có thể giúp hình thành các phân tử cần thiết để bắt đầu sự sống giống như Trái Đất.",
    ];
    String imageUrl6 = "http://static.muctim.com.vn/data/teen360/pictures/2022/04/11/1649647356_b--m-t.jpg";
    String imageNotes6 = "Bề mặt sao Kim lỗ chỗ do có nhiều hố va chạm.";
    String imageCredit6 = "";

    List<String> contentsMore6 = [
      "Theo các nhà thiên văn học, có khoảng hơn 1.000 hố va chạm phân bố khắp bề mặt sao Kim. Và 85% hố va chạm vẫn còn ở trạng thái nguyên thủy. Áp suất khí quyển trên sao Kim lớn hơn ở Trái Đất 92 lần.",
    ];

    Map images6 = {
      "imageCredit": imageCredit6,
      "imageNotes": imageNotes6,
      "imageUrl": imageUrl6,
    };

    String tagsContents6 = "";
    Map contentDetail6 = {
      "caption": caption6,
      "contents": contents6,
      "contentsMore": contentsMore6,
      "images": images6,
      "tags": tagsContents6,
    };

    /////////////////////////////////////////////////////////////
    //////////////////////////// CONTENT List 7//////////////////////////////
    String caption7 = "Thám hiểm sao Kim";
    List<String> contents7 = [
      "Hoa Kỳ, Liên Xô, Cơ quan Vũ trụ Châu u và Cơ quan Thám hiểm Hàng không Vũ trụ Nhật Bản đã triển khai nhiều tàu vũ trụ đến Sao Kim - hơn 20 chiếc cho đến nay.",
      "Mariner 2 của NASA cách Sao Kim 34.760 km vào năm 1962, trở thành hành tinh đầu tiên được quan sát bởi một tàu vũ trụ đi qua.",
      "Venera 7 của Liên Xô là tàu vũ trụ đầu tiên hạ cánh trên một hành tinh khác, đáp xuống Sao Kim vào tháng 12 năm 1970. Venera 9 đã quay lại những bức ảnh đầu tiên về bề mặt Sao Kim.",
      "Tàu quỹ đạo sao Kim đầu tiên, Magellan của NASA, đã tạo ra bản đồ của 98% bề mặt hành tinh, cho thấy các đặc điểm có chiều ngang nhỏ tới 100m.",
      "Tàu Venus Express của Cơ quan Vũ trụ Châu Âu đã dành 8 năm trên quỹ đạo xung quanh Sao Kim với nhiều loại thiết bị và xác nhận sự hiện diện của tia sét ở đó. Đến tháng 12 năm 2014, tàu vũ trụ hết thuốc phóng và cuối cùng bốc cháy trong bầu khí quyển của Sao Kim. Năm 2021, NASA đã công bố 2 con tàu vũ trụ mới tới Sao Kim sẽ khởi động vào năm 2030.",
    ];
    String imageUrl7 = "";
    String imageNotes7 = "";
    String imageCredit7 = "";

    List<String> contentsMore7 = [];

    Map images7 = {
      "imageCredit": imageCredit7,
      "imageNotes": imageNotes7,
      "imageUrl": imageUrl7,
    };

    String tagsContents7 = "";
    Map contentDetail7 = {
      "caption": caption7,
      "contents": contents7,
      "contentsMore": contentsMore7,
      "images": images7,
      "tags": tagsContents7,
    };

    /////////////////////////////////////////////////////////////
    // //////////////////////////// CONTENT List 7//////////////////////////////
    // String caption7 = "Sức nóng của mặt trời";
    // List<String> contents7 = [
    //   "Mặt trời rất – rất nóng , tính riêng phần lõi của Mặt Trời nơi các phản ứng nhiệt hạch xảy ra không ngừng nghỉ thì nhiệt độ lên tới 17 triệu độ C. Trong khi nhiệt độ bề mặt chỉ rơi vào khoảng 7000 độ C.",
    // ];
    // String imageUrl7 = "";
    // String imageNotes7 = "";
    // String imageCredit7 = "";

    // List<String> contentsMore7 = [];

    // Map images7 = {
    //   "imageCredit": imageCredit7,
    //   "imageNotes": imageNotes7,
    //   "imageUrl": imageUrl7,
    // };

    // String tagsContents7 = "";
    // Map contentDetail7 = {
    //   "caption": caption7,
    //   "contents": contents7,
    //   "contentsMore": contentsMore7,
    //   "images": images7,
    //   "tags": tagsContents7,
    // };

    // /////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////

    List<Map> content = [
      contentDetail,
      contentDetail1,
      contentDetail2,
      contentDetail3,
      contentDetail4,
      contentDetail5,
      contentDetail6,
      contentDetail7,
    ];
    /////////////////////////////////////////////////////////////
    ///
    List<String> tags = ["Vũ trụ", "Nasa", "Trái Đất"];

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return homedata
          .add({
            "titleDisplay": titleDisplay,
            "guideTitle": guideTitle,
            "author": author,
            "content": content,
            "date": date,
            "tags": tags,
            "title": title,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
