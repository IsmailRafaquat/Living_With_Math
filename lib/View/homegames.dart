import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_brain/View/ASMD/Addition.dart';
import 'package:quiz_brain/View/ASMD/Division.dart';
import 'package:quiz_brain/View/ASMD/Multiplication.dart';
import 'package:quiz_brain/View/ASMD/Subtraction.dart';
import 'package:quiz_brain/View/TopGames/Balance.dart';
import 'package:quiz_brain/View/TopGames/HardMath.dart';
import 'package:quiz_brain/View/TopGames/False.dart';
import 'package:quiz_brain/View/TopGames/GreaterLesser.dart';
import 'package:quiz_brain/View/TopGames/Squares.dart';
import 'package:quiz_brain/View/TopGames/Tables.dart';
import 'package:quiz_brain/colors/colors.dart';
import 'package:quiz_brain/components/HomeContainer.dart';

class HomeGames extends StatefulWidget {
  const HomeGames({Key? key}) : super(key: key);

  @override
  _HomeGamesState createState() => _HomeGamesState();
}

class _HomeGamesState extends State<HomeGames> {
  bool isBannerLoading = false;
  late BannerAd bannerAd;

  void initializeBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // Test Ad Unit ID
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoading = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            isBannerLoading = false;
          });
          print('Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    initializeBannerAd();
  }

  @override
  void dispose() {
    bannerAd.dispose(); // Dispose the ad when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double gameContainerWidth = MediaQuery.of(context).size.width * 0.45;
    final double gameContainerHeight =
        MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        foregroundColor: AppColor.WhiteColor,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Brain Games',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: AppColor.AppBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildGameRow([
              HomeContainer(
                onpress: () {
                  Get.to(const BalanceAdvance());
                },
                title: 'Balance',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/balance (2).svg',
              ),
              HomeContainer(
                onpress: () {
                  Get.to(const HardMath());
                },
                title: 'Hard Math',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/HardMath.svg',
              ),
            ]),
            buildGameRow([
              HomeContainer(
                onpress: () {
                  Get.to(GreaterLesserScreen());
                },
                title: 'Greater>|<Less',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/Greater.svg',
              ),
              HomeContainer(
                onpress: () {
                  Get.to(const TrueFalseQuizScreen());
                },
                title: 'True|False',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/TrueFalse.svg',
              ),
            ]),
            buildGameRow([
              HomeContainer(
                onpress: () {
                  Get.to(const MultiplicationAdvance());
                },
                title: 'Multiplication',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/Multipication1.svg',
              ),
              HomeContainer(
                onpress: () {
                  Get.to(const AdditionAdvance());
                },
                title: 'Addition',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/Addition.svg',
              ),
            ]),
            buildGameRow([
              HomeContainer(
                onpress: () {
                  Get.to(const SubtractionAdvance());
                },
                title: 'Subtraction',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/Subtraction.svg',
              ),
              HomeContainer(
                onpress: () {
                  Get.to(const DivisionAdvance());
                },
                title: 'Division',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/Division.svg',
              ),
            ]),
            buildGameRow([
              HomeContainer(
                onpress: () {
                  Get.to(const TableAdvance());
                },
                title: 'Tables',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/MathTable.svg',
              ),
              HomeContainer(
                onpress: () {
                  Get.to(const SquaresAdvance());
                },
                title: 'Squares',
                width: gameContainerWidth,
                height: gameContainerHeight,
                svgPath: 'assets/images/Square.svg',
              ),
            ]),
            if (isBannerLoading)
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                child: AdWidget(ad: bannerAd),
              ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'New games are coming soon!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGameRow(List<Widget> games) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: games
            .map((game) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: game,
                ))
            .toList(),
      ),
    );
  }
}
