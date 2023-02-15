import 'dart:math';

class Question {
  final String questionText;
  final List<Answer> answersList;
  final String tags;
  final String more;

  Question(this.questionText, this.answersList, this.tags, this.more);
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer(this.answerText, this.isCorrect);
}

List<Question> getQuestions() {
  List<Question> list = [
    Question(
      "Hành tinh nào gần nhất với Mặt Trời?",
      [
        Answer("Trái Đất", false),
        Answer("Sao Hoả", false),
        Answer("Sao Mộc", false),
        Answer("Sao Thủy", true),
      ],
      "Câu trả lời đúng là Sao Thủy đây là hành tinh gần Mặt Trời nhất và là hành tinh nhỏ nhất trong Hệ Mặt Trời (0,055 lần khối lượng Trái Đất).",
      "saothuy",
    ),
    Question(
      "Hành tinh nào lớn nhất trong hệ Mặt Trời?",
      [
        Answer("Trái Đất", false),
        Answer("Sao Mộc", true),
        Answer("Sao Thổ", false),
        Answer("Sao Thiên Vương", false),
      ],
      "Câu trả lời đúng là Sao Mộc Hành tinh thứ 5 trong Hệ Mặt trời - Jupiter, Sao Mộc chính là một thế giới khí khổng lồ. Đây là hành tinh lớn nhất trong Thái Dương hệ của chúng ta. ",
      "saomoc",
    ),
    Question(
      "Hành tinh nào có bề mặt gần giống như Trái Đất?",
      [
        Answer("Sao Kim", true),
        Answer("Sao Thuỷ", false),
        Answer("Sao Mộc", false),
        Answer("Sao Hoả", false),
      ],
      "Câu trả lời đúng là Sao Kim, Sao Kim là một trong bốn hành tinh đất đá trong Hệ Mặt trời, có nghĩa là, giống như Trái đất, nó là một vật thể bằng đá. Về kích thước và khối lượng, nó rất giống với hành tinh của chúng ta.",
      "saokim",
    ),
    Question(
        "Hành tinh nào có quỹ đạo quanh Mặt Trời nhanh nhất?",
        [
          Answer("Sao Thuỷ", true),
          Answer("Sao Kim", false),
          Answer("Trái Đất", false),
          Answer("Sao Hoả", false),
        ],
        "Tốc độ quay quanh mặt trời của sao Thủy rất nhanh, khoảng 88 ngày Trái đất. Trong khi đó, sao Thủy cần khoảng 58 ngày Trái đất để tự quay quanh trục. Như vậy, một năm ở sao Thủy quá nhanh, chỉ 88 ngày so với 365 ngày trên hành tinh chúng ta còn một ngày lại dài khủng khiếp, bằng khoảng 2 tháng Trái đất.",
        "saothuy"),
    Question(
        "Hành tinh nào là hành tinh lớn nhất trong hệ Mặt Trời ngoài Sao Mộc?",
        [
          Answer("Trái Đất", false),
          Answer("Sao Thổ", true),
          Answer("Sao Thủy", false),
          Answer("Sao Kim", false),
        ],
        "Sao Thổ là hành tinh thứ sáu từ Mặt Trời trở ra và hành tinh lớn thứ hai trong hệ Mặt Trời, sau Sao Mộc. Theo Universe Today, khi so sánh với Trái Đất, đường kính xích đạo của Sao Thổ là 120.536 km, gấp khoảng 9,5 lần.",
        "saotho"),
    Question(
        "Hành tinh nào có quỹ đạo gần nhất với Mặt Trời?",
        [
          Answer("Trái Đất", false),
          Answer("Sao Hoả", false),
          Answer("Sao Thủy", true),
          Answer("Sao Mộc", false),
        ],
        "Sao Thủy hay còn gọi là Thủy tinh, tên tiếng anh là Mercury, sao chỉ lớn hơn so với Mặt trăng của Trái đất một chút, là hành tinh nằm gần nhất với Mặt trời, với chu kỳ quỹ đạo bằng 88 ngày Trái đất.",
        "saothuy"),
    Question(
        "Hành tinh nào có trọng lượng lớn nhất trong hệ mặt trời?",
        [
          Answer("Trái Đất", false),
          Answer("Sao Mộc", true),
          Answer("Sao Thủy", false),
          Answer("Sao Hoả", false),
        ],
        "Sao Mộc hay còn gọi là Jupiter, là hành tinh lớn nhất trong hệ mặt trời, có trọng lượng gấp đôi cả các hành tinh khác cùng tổng lại. Nó là một hành tinh gần gũi với Mặt trời và có nhiều hạt với những vòng quỹ rộng lớn.",
        "saomoc"),
    Question(
      "Hành tinh nào có chu kỳ quỹ đạo ngắn nhất trong hệ mặt trời?",
      [
        Answer("Sao Mộc", true),
        Answer("Sao Thủy", false),
        Answer("Jupiter", false),
        Answer("Sao Hoả", false),
      ],
      "Sao Mộc hay còn gọi là Mộc tinh, tên tiếng anh là Venus, sao có chu kỳ quỹ đạo ngắn nhất trong hệ mặt trời với chỉ 225 ngày Trái đất.",
      "saomoc",
    ),
    Question(
      "Con người đã bao giờ đặt chân lên Sao Hỏa chưa?",
      [
        Answer("Đã từng đặt chân lên Sao Hoả", false),
        Answer("Chưa từng đặt chân lên Sao Hoả", true),
      ],
      "Rõ ràng, mặc dù con người chưa hề đặt chân lên Sao Hỏa, nhưng rác thải đã nhanh chóng trở thành một vấn đề cần có sự can thiệp của các tổ chức không gian, nếu không muốn biến đây trở thành 'bãi phế liệu'.",
      "",
    ),
  ];
  //ADD questions and answer here
  var random = Random();
  list.shuffle(random);
  list = list.sublist(0, 9);
  return list;
}
