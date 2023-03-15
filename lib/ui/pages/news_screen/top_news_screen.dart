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

  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _usersdataDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData().then((usersdata) {
      setState(() {
        isLoading = false;
        _usersdataDataList = usersdata;
      });
    });
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
        body: Scrollbar(
            child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            _buildTitleWelcome(context, result),
            _addDataToList(data, result, context),
            tagsButton != "Tất cả" ? CardNewsWithTags(data: data, tagsButton: tagsButton, checktags: true) : CardNewsWithTags(data: data, tagsButton: tagsButton)
          ],
        )));
  }

  SliverToBoxAdapter _addDataToList(CollectionReference<Object?> data, List<dynamic> result, BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            child: StreamBuilder(
                stream: data.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {}
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
    );
  }

  Widget _buildTitleWelcome(BuildContext context, List<dynamic> result) {
    return SliverAppBar(
      expandedHeight: 140,
      leading: const SizedBox(),
      floating: false,
      pinned: true,
      backgroundColor: OneColors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
            padding: const EdgeInsets.only(top: 60, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: _usersdataDataList
                        .where((element) => element["email"] == user?.email)
                        .take(1)
                        .map(
                          (e) => Text(
                            "Hi, ${e["name"]}",
                            style: OneTheme.of(context).header.copyWith(fontSize: 19),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Khám phá vũ trụ nào!",
                    style: OneTheme.of(context).header.copyWith(fontSize: 23),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(top : 10.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            tagsButtonView("Tất cả"),
                            _buildListTags(result),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),

                    //Text(textHolder),
                    tagsButton != "Tất cả" ? _titleTagsButton(context) : const SizedBox(),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Align _titleTagsButton(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: RichText(
            text: TextSpan(
              text: 'Bạn đang tìm kiếm với từ khoá : ',
              style: DefaultTextStyle.of(context).style.copyWith(color: OneColors.black),
              children: <TextSpan>[
                TextSpan(text: tagsButton, style: const TextStyle(fontWeight: FontWeight.bold, color: OneColors.textOrange)),
              ],
            ),
          ),
        ));
  }

  SizedBox _buildListTags(List<dynamic> result) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: result.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tagsButtonView(result[index]),
            ],
          );
        },
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
        height: 40,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: OneColors.white, boxShadow: const [
          BoxShadow(
            color: OneColors.grey,
            blurRadius: 4,
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                label,
                style: OneTheme.of(context).header.copyWith(color: OneColors.black, fontSize: 12, fontWeight: FontWeight.w400),
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
