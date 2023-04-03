// ignore_for_file: file_names, duplicate_ignore, prefer_typing_uninitialized_variables

part of '../../../libary/one_libary.dart';

class P3DView extends StatelessWidget {
  P3DView({
    Key? key,
    required this.argument,
  }) : super(key: key);

  final argument;

  final CollectionReference modeldata = FirebaseFirestore.instance.collection("modeldata");

  // List<String> url = [
  @override
  Widget build(BuildContext context) {
    String imageUrl = argument["image3D"]["imageUrl"];
    String idName = argument["idName"];
    //String imageUrl = "https://webar.cartmagician.com/7979_vũ/p24183c4842/489996/earth.glb";
    //String imageUrl = url[0];
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          argument["name"],
          style: OneTheme.of(context).header.copyWith(color: OneColors.black),
        ),
        centerTitle: true,
        backgroundColor: OneColors.white,
        elevation: 2,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: OneColors.black), onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: OneColors.white,
      body: Stack(
        children: [
          BabylonJSViewer(
            src: imageUrl,
          ),
          _buildButtonMore(context, idName)
        ],
      ),
    );
  }

  Align _buildButtonMore(BuildContext context, String idName) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: OneColors.transparent,
            context: context,
            builder: (context) {
              return _buildCardMore(context, idName);
            },
          );
        },
        child: Container(
          height: 55,
          width: 55,
          margin: const EdgeInsets.only(right: 20, bottom: 20),
          decoration: BoxDecoration(
              color: OneColors.bgButton,
              boxShadow: const [
                BoxShadow(
                  color: OneColors.grey,
                  blurRadius: 4,
                ),
              ],
              border: Border.all(color: OneColors.white, width: 1),
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "Xem thêm",
              style: OneTheme.of(context).body1.copyWith(color: OneColors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Container _buildCardMore(BuildContext context, String idName) {
    return Container(
      height: AppContants.sizeHeight * 0.4,
      decoration: const BoxDecoration(color: OneColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
              child: Container(
                height: 60,
                color: OneColors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Mọi người cũng\ntìm kiếm",
                              style: OneTheme.of(context).header.copyWith(color: OneColors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Xem thêm hơn 10 mục khác",
                          style: OneTheme.of(context).caption1.copyWith(color: OneColors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          CardPlanets(
            data: modeldata,
            currentPlanets: idName,
            titleColor: OneColors.black,
          )
        ],
      ),
    );
  }
}
