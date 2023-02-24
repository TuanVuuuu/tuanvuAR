// ignore_for_file: avoid_print

import 'dart:math';

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
    String author = "Trí Thức Trẻ"; // Tên tác giả

    final DateTime now = DateTime.now();
    final Timestamp date = Timestamp.fromDate(now);

    ///
    String title = "Chiêm ngưỡng tấm hình ấn tượng của sao Mộc do kính viễn vọng ghi lại"; //Tên tiêu đề
    // tên tiêu đề sẽ hiển thị ở bên ngoài
    String titleDisplay =
        "Từ trường của sao Mộc cao hơn của Trái Đất hàng trăm lần nên hiện tượng cực quang trên hành tinh này không bao giờ ngừng lại và có cường độ lớn hơn nhiều so với trên Trái Đất.";

    ///
    String guideTitle =
        "Từ trường của sao Mộc cao hơn của Trái Đất hàng trăm lần nên hiện tượng cực quang trên hành tinh này không bao giờ ngừng lại và có cường độ lớn hơn nhiều so với trên Trái Đất.";

    ////////////////// CONTENT List 1///////////////////////////////
    String caption = "";
    List<String> contents = [
      "Hình ảnh ấn tượng mà các bạn đang xem là cực quang trong dải cực tím được kính viễn vọng 'Hubble' chụp ở cực bắc của sao Mộc. Tờ EurekAlert dẫn lời các chuyên gia cho biết: đây là một trong số những bức hình vũ trụ có nhiều màu sắc nhất mà loài người chúng ta từng chụp được.",
    ];
    String imageUrl = "https://e.khoahoc.tv/photos/image/2016/07/05/cuc-quang-tren-sao-moc.jpg";
    String imageNotes = "Cực quang trong dải cực tím được kính viễn vọng 'Hubble' chụp ở cực bắc của sao Mộc.";
    String imageCredit = "";

    Map images = {
      "imageCredit": imageCredit,
      "imageNotes": imageNotes,
      "imageUrl": imageUrl,
    };
    List<String> contentsMore = [
      "Cơ chế hình thành cực quang trên sao Mộc cũng giống như trên Trái Đất, chúng sinh ra khi các hạt gió mặt trời manh năng lượng cao và được định hướng bởi từ trường đi vào khí quyển của hành tinh tại vùng cực. Tuy nhiên, do từ trường của sao Mộc cao hơn của Trái Đất hàng trăm lần nên hiện tượng cực quang trên hành tinh này không bao giờ ngừng lại và có cường độ lớn hơn nhiều so với trên Trái Đất.",
    ];

    String tagsContents = "";
    Map contentDetail = {
      "caption": caption,
      "contents": contents,
      "contentsMore": contentsMore,
      "images": images,
      "tags": tagsContents,
    };

    /////////////////// CONTENT List 2//////////////////////////////
    String caption1 = "";
    List<String> contents1 = [];
    String imageUrl1 = "https://e.khoahoc.tv/photos/image/2016/07/05/cuc-quang-tren-sao-moc-1.jpg";
    String imageNotes1 =
        "Cực quang sao Mộc này chứa năng lượng gấp hàng trăm lần các hiện tượng cực quang diễn ra trên Trái đất. Đồng thời, thay vì các cơn bão mặt trời, bão từ làm xuất hiện cực quang trên Trái đất thì cực quang trên sao Mộc có thể hình thành bởi một nguồn tác động khác.";
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
    String caption2 = "Tấm ảnh khó tin";
    List<String> contents2 = [
      "Mỗi tháng một lần 'Hubble' lại theo dõi cực quang trên sao Mộc. Các chuyên gia NASA và ESA (Cơ quan Vũ trụ châu Âu) đã so sánh hai hình ảnh: một tấm do kính thiên văn 'Hubble' chụp trong dải cực tím, và tấm thứ hai chụp năm 2014 ở bước sóng hồng ngoại. Kết quả rất ấn tượng.",
    ];
    String imageUrl2 = "https://e.khoahoc.tv/photos/image/2016/07/07/sao-tho-2.jpg";
    String imageNotes2 = "Hiện tượng cực quang nổi bật trong không gian với màu xanh trắng, hoạt động thành các vòng xoáy rõ rệt trên cực Bắc sao Mộc.";
    String imageCredit2 = "Dailymail";

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
    String caption3 = "";
    List<String> contents3 = [];
    String imageUrl3 = "https://e.khoahoc.tv/photos/image/2016/07/07/sao-tho-3.jpg";
    String imageNotes3 = "Theo các chuyên gia nhận định, rất nhiều tia cực tím, tia X-ray cực quang lẫn gió mặt trời và khí bụi va chạm xuất hiện trong hệ thống này.";
    String imageCredit3 = "Dailymail";

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
    String caption4 = "";
    List<String> contents4 = [];

    String imageUrl4 = "https://e.khoahoc.tv/photos/image/2016/07/07/sao-tho-4.jpg";
    String imageNotes4 = 'Tiến sĩ Jonathan Nichols, một nhà khoa học không gian tại Đại học Leicester cho biết: "Đây là hiện tượng cực quang kịch tính và đẹp nhất mà tôi từng thấy...".';
    String imageCredit4 = "Dailymail";

    List<String> contentsMore4 = [];

    Map images4 = {
      "imageCredit": imageCredit4,
      "imageNotes": imageNotes4,
      "imageUrl": imageUrl4,
    };

    String tagsContents4 = "saomoc";
    Map contentDetail4 = {
      "caption": caption4,
      "contents": contents4,
      "contentsMore": contentsMore4,
      "images": images4,
      "tags": tagsContents4,
    };

    /////////////////////////////////////////////////////////////
    //////////////////////////// CONTENT List 5//////////////////////////////
    String caption5 = "5. Sao Hỏa từng có nước";
    List<String> contents5 = [
      "Một trong những sự thật được biết đến nhiều nhất về sao Hỏa là nó từng có một lượng lớn nước lỏng. Hàng tỉ năm trước, sao Hỏa có bầu khí quyển dày đặc và hiệu ứng nhà kính mạnh - điều kiện cho phép tồn tại nước lỏng, mặc dù thực tế là sao Hỏa quay quanh khu vực có thể ở của mặt trời.",
      "Các nhà khoa học đã tìm thấy bằng chứng rõ ràng về các sông, hồ, biển và thậm chí cả đại dương cổ đại trên bề mặt sao Hỏa, cho thấy có khả năng đã từng tồn tại sự sống trên sao Hỏa.",
    ];
    String imageUrl5 = "https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/7/20/1070757/Nuoc-Sao-Hoa.jpg";
    String imageNotes5 = "Sao Hoả từng có nước.";
    String imageCredit5 = "NASA";

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
    String caption6 = "6. Khí quyển của sao Hỏa đã bị Mặt trời phá hủy";
    List<String> contents6 = [
      "Trong quá khứ, sao Hỏa có một bầu khí quyển có mật độ tương đương với Trái đất, nhưng ngày nay, bầu khí quyển của sao Hỏa là không đáng kể. Không giống như Trái đất, sao Hỏa không còn từ trường có thể làm lệch hướng bức xạ mặt trời.",
      "Việc thiếu từ trường có thể xảy ra khi lõi của sao Hỏa đông đặc lại. Không có từ trường, sao Hỏa không có sự bảo vệ chống lại bức xạ mặt trời, bức xạ này từ từ tước bỏ bầu khí quyển của sao Hỏa.",
    ];
    String imageUrl6 = "";
    String imageNotes6 = "";
    String imageCredit6 = "";

    List<String> contentsMore6 = [];

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
    String caption7 = "7. Sao Hỏa là hành tinh duy nhất có robot";
    List<String> contents7 = [
      "Sao Hỏa hiện là hành tinh duy nhất trong hệ mặt trời có robot cư trú. Hiện tại có 5 tàu thám hiểm trên bề mặt sao Hỏa. Nhân loại hiện không có robot trên hành tinh nào khác, biến sao Hỏa trở thành hành tinh của robot.",
    ];
    String imageUrl7 = "https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/7/20/1070757/Tau-Sao-Hoa.jpg";
    String imageNotes7 = "Tàu thám hiểm trên sao Hoả";
    String imageCredit7 = "NASA";

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
    /////////////////////////////// CONTENT List 8//////////////////////////////

    String caption8 = "8. Hoàng hôn trên sao Hỏa có màu xanh";
    List<String> contents8 = [
      "Trên Trái đất, hoàng hôn có màu cam và vàng, còn bầu trời ban ngày của chúng ta có màu xanh. Trên sao Hỏa, gần như điều ngược lại xảy ra. Vào ban ngày, bầu trời sao Hỏa có màu đỏ, trong khi hoàng hôn có màu xanh. Khi mặt trời lặn trên sao Hỏa, ánh sáng đỏ từ mặt trời bị lọc ra và ánh sáng xanh bị phân tán, làm cho hoàng hôn có màu xanh.",
    ];
    String imageUrl8 = "";
    String imageNotes8 = "";
    String imageCredit8 = "";

    List<String> contentsMore8 = [];

    Map images8 = {
      "imageCredit": imageCredit8,
      "imageNotes": imageNotes8,
      "imageUrl": imageUrl8,
    };

    String tagsContents8 = "";
    Map contentDetail8 = {
      "caption": caption8,
      "contents": contents8,
      "contentsMore": contentsMore8,
      "images": images8,
      "tags": tagsContents8,
    };
    //////////////////////////// CONTENT List 9//////////////////////////////

    String caption9 = "9. Sao Hỏa sẽ có quầng vào một ngày nào đó";
    List<String> contents9 = [
      "Mặt trăng lớn nhất của sao Hỏa, Phobos, đang dần di chuyển đến gần sao Hỏa. Các nhà thiên văn ước tính rằng trong khoảng 500 triệu năm nữa, Phobos sẽ ở gần sao Hỏa đến mức nó sẽ bị xé toạc bởi lực hấp dẫn của sao Hỏa hoặc sẽ đâm vào bề mặt. Dù bằng cách nào, kết quả sẽ là sự hình thành của một hệ thống quầng nhỏ xung quanh sao Hỏa.",
    ];
    String imageUrl9 = "";
    String imageNotes9 = "";
    String imageCredit9 = "";

    List<String> contentsMore9 = [];

    Map images9 = {
      "imageCredit": imageCredit9,
      "imageNotes": imageNotes9,
      "imageUrl": imageUrl9,
    };

    String tagsContents9 = "";
    Map contentDetail9 = {
      "caption": caption9,
      "contents": contents9,
      "contentsMore": contentsMore9,
      "images": images9,
      "tags": tagsContents9,
    };
    //////////////////////////// CONTENT List 10//////////////////////////////

    String caption10 = "10. Bão bụi làm cho bầu trời của sao Hỏa có màu đỏ";
    List<String> contents10 = [
      "Sao Hỏa thường không có bầu trời đỏ. Sở dĩ bầu trời có màu đỏ là do các cơn bão bụi phát tán các hạt bụi vào bầu khí quyển, khiến bầu trời có màu đỏ hồng.",
    ];
    String imageUrl10 = "";
    String imageNotes10 = "";
    String imageCredit10 = "";

    List<String> contentsMore10 = [];

    Map images10 = {
      "imageCredit": imageCredit10,
      "imageNotes": imageNotes10,
      "imageUrl": imageUrl10,
    };

    String tagsContents10 = "saohoa";
    Map contentDetail10 = {
      "caption": caption10,
      "contents": contents10,
      "contentsMore": contentsMore10,
      "images": images10,
      "tags": tagsContents10,
    };
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
      // contentDetail5,
      // contentDetail6,
      // contentDetail7,
      // contentDetail8,
      // contentDetail9,
      // contentDetail10,
    ];
    /////////////////////////////////////////////////////////////
    ///
    List<String> tags = ["Cực Quang", "Sao Mộc"];
    var random = Random().nextInt(1000) + 50;
    int views = random;

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
            "views": views,
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
