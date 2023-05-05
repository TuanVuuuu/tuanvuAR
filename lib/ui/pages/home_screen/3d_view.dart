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
    final GlobalKey webViewKey = GlobalKey();
    InAppWebViewController? webViewController;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    AppContants.init(context);
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
        clipBehavior: Clip.none,
        children: [
          // BabylonJSViewer(
          //   src: imageUrl,
          // ),
          Positioned(
            top: -210,
            child: SizedBox(
              height: AppContants.sizeHeight + 210,
              width: AppContants.sizeWidth,
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                  url: Uri.parse(imageUrl),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                },
              ),
              // WebView(
              //   initialUrl: Uri.encodeFull(imageUrl),
              //   debuggingEnabled: false,
              //   backgroundColor: OneColors.transparent,
              //   javascriptMode: JavascriptMode.unrestricted,
              // ),
            ),
          ),
          _buildButtonMore(context, idName),
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
      height: AppContants.sizeHeight * 0.42,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          image: DecorationImage(
              image: AssetImage(
                OneImages.bg3,
              ),
              fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  height: 5,
                  width: 60,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: OneColors.white,
                    borderRadius: BorderRadius.circular(30),
                  ))),
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
                              style: OneTheme.of(context).header.copyWith(color: OneColors.white),
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
                          style: OneTheme.of(context).caption1.copyWith(color: OneColors.white, fontWeight: FontWeight.w400),
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
            titleColor: OneColors.white,
          )
        ],
      ),
    );
  }
}
