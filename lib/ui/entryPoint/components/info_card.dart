import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
    required this.bio,
  }) : super(key: key);

  final String name, bio;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: OneColors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: OneColors.white,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(color: OneColors.white),
      ),
      subtitle: Text(
        bio,
        style: const TextStyle(color: OneColors.white70),
      ),
    );
  }
}
