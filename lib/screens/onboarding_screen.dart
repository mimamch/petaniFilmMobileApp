import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/main.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScaffold(),
          ),
          (Route<dynamic> route) => false);
    });

    return Scaffold(
      backgroundColor: Constants.kWhiteColor.withOpacity(0.85),
      extendBody: true,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Petani Film',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.kBlackColor.withOpacity(0.85),
                  fontSize: screenHeight <= 667 ? 18 : 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Watch Your Favorite Movie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.kBlackColor.withOpacity(0.75),
                  fontSize: screenHeight <= 667 ? 10 : 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
