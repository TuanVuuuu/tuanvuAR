part of '../../../libary/one_libary.dart';

class CardNews extends StatelessWidget {
  const CardNews({
    Key? key,
    required this.data,
    this.cardLength,
  }) : super(key: key);

  final CollectionReference<Object?> data;
  final int? cardLength;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          StreamBuilder(
            stream: data.snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(
                  child: OneLoadingShimmer(
                    itemCount: 5,
                  ),
                );
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: cardLength ?? snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot records = snapshot.data.docs[snapshot.data?.docs.length - index - 1];
                    Timestamp time = records["date"];
                    var dateFormat = DateFormat.yMMMMd('en_US').add_jm().format(DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch));
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: InkWell(
                        onTap: (() => Get.to(() => DetailNewsScreen(argument: records), curve: Curves.linear, transition: Transition.rightToLeft)),
                        child: OneCard(
                          color: OneColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(7),
                          child: (records["content"][0]["images"]["imageUrl"] != null && records["content"][0]["images"]["imageUrl"] != "")
                              ? OneCardNewsImage(records: records, dateFormat: dateFormat)
                              : OneCardNewsNoImage(records: records, dateFormat: dateFormat),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                  child: OneLoadingShimmer(
                itemCount: 5,
              ));
            }),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
