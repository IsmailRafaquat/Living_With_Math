import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_brain/View/homegames.dart';
import 'package:quiz_brain/colors/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    
    @override
    void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
      Get.off(()=>const HomeGames());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).size.height * 0.85;
    final double textPadding = MediaQuery.of(context).size.height * 0.94;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child:   Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.only(top: textPadding),
              child: const Center(child: Text('Loading....',style: TextStyle(color: AppColor.WhiteColor),))
            ),
          ],
        ),
      ),
    );
  }
}
