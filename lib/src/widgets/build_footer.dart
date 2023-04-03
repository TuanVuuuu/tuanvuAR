import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';
import 'package:flutter_application_1/src/shared/contant.dart';

class BuildFooter extends StatelessWidget {
  const BuildFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: AppContants.sizeWidth,
          height: 1,
          color: OneColors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              //color: Colors.amber,
              width: AppContants.sizeWidth * 0.33,
              child: const Text(
                "©TuanVu, 2023",
                style: TextStyle(color: OneColors.grey),
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(
                width: AppContants.sizeWidth * 0.67,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ignore: sized_box_for_whitespace
                    Container(
                      //color: Colors.green,
                      width: AppContants.sizeWidth * 0.33,
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(color: OneColors.grey),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                    // ignore: sized_box_for_whitespace
                    Container(
                      //color: Colors.blue,
                      width: AppContants.sizeWidth * 0.33,
                      child: const Text(
                        "Terms of Service",
                        style: TextStyle(color: OneColors.grey),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ))
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
