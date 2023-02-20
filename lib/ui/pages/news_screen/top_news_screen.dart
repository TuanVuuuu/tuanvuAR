// ignore_for_file: unused_element

part of '../../../libary/one_libary.dart';

class TopNewsScreen extends StatefulWidget {
  const TopNewsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TopNewsScreen> createState() => _TopNewsScreenState();
}

class _TopNewsScreenState extends State<TopNewsScreen> {
  String tagsButton = "Tất cả";
  List dataList = [];
  List<String> tagsButtonList = [];
  List<String> docIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference data = FirebaseFirestore.instance.collection("homedata");
    List result = Set.of(tagsButtonList).toList();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: OneColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: OneColors.transparent, // Color for Android
        statusBarBrightness: Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    return AppScaffold(
        backgroundColor: OneColors.white,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(OneImages.bg3),
              fit: BoxFit.cover,
            ),
          ),
          child: Scrollbar(
              child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              // _buildTopNews(context, result),
              _addDataToList(data, result, context),

              tagsButton != "Tất cả"
                  ? CardNewsWithTags(data: data, tagsButton: tagsButton)
                  : CardNews(
                      data: data,
                    )
            ],
          )),
        ));
  }

  SliverToBoxAdapter _addDataToList(CollectionReference<Object?> data, List<dynamic> result, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  child: StreamBuilder(
                      stream: data.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          const Center(
                              child: OneLoadingShimmer(
                            itemCount: 5,
                          ));
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot records = snapshot.data!.docs[index];
                              return Padding(
                                  padding: EdgeInsets.zero,
                                  child: (() {
                                    for (int i = 0; i < records["tags"].length; i++) {
                                      if (result.isEmpty && dataList != []) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                                              tagsButtonList.add(records["tags"][i]);
                                              dataList.add(records["title"]);
                                            }));
                                      }
                                    }

                                    return Container();
                                  })());
                            },
                          );
                        }

                        return Container();
                      }),
                ),
              ],
            ),

            //Có thể bạn chưa biết
            _buildTitle(context),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  tagsButtonView("Tất cả"),
                  _buildListTags(result),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            //Text(textHolder),
            tagsButton != "Tất cả" ? _titleTagsButton(context) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Align _titleTagsButton(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: 'Bạn đang tìm kiếm với từ khoá : ',
            style: DefaultTextStyle.of(context).style.copyWith(color: OneColors.white),
            children: <TextSpan>[
              TextSpan(text: tagsButton, style: const TextStyle(fontWeight: FontWeight.bold, color: OneColors.textOrange)),
            ],
          ),
        ));
  }

  Padding _buildListTags(List<dynamic> result) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: result.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                tagsButtonView(result[index]),
              ],
            );
          },
        ),
      ),
    );
  }

  Align _buildTitle(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Có thể bạn chưa biết!",
        style: OneTheme.of(context).header.copyWith(color: OneColors.white),
      ),
    );
  }

  Widget tagsButtonView(String label) {
    return InkWell(
      onTap: (() {
        setState(() {
          tagsButton = label;
        });
      }),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: OneColors.blue100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(color: OneColors.brandVNP),
              )),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
