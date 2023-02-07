import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator SplashWidget - FRAME
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(6.123234262925839e-17, 1),
              end: Alignment(-1, 6.123234262925839e-17),
              colors: [Color.fromRGBO(12, 111, 202, 1), Color.fromRGBO(38, 0, 111, 1), Color.fromRGBO(75, 3, 132, 1)]),
          image: DecorationImage(image: AssetImage("assets/images/bg/bg1.png"), fit: BoxFit.cover)),
    );
  }
}
