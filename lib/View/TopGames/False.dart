import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:quiz_brain/View/homegames.dart';
import 'package:quiz_brain/colors/colors.dart';
import 'package:quiz_brain/components/dialoguebox.dart';
import 'package:quiz_brain/list/list.dart';

class TrueFalseQuizScreen extends StatefulWidget {
  const TrueFalseQuizScreen({super.key});

  @override
  State<TrueFalseQuizScreen> createState() => _TrueFalseQuizScreenState();
}

class _TrueFalseQuizScreenState extends State<TrueFalseQuizScreen> with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  Timer? _timer;
  int _start = 10;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    QuestionList.questions.shuffle();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _animationController.reset();
    _animationController.forward();
    _start = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        showTimeOutDialog();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void showTimeOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => CustomAlertDialog(
        heading: 'Time Out!',
        title: 'You did not answer in time. Try again.',
        onPress: () {
          Navigator.of(ctx).pop();
          Get.off(const HomeGames());
        },
        imagePath: 'assets/images/wrong.jpg',
        icons: Icons.warning,
        width: MediaQuery.of(ctx).size.width * 0.5,
        height: MediaQuery.of(ctx).size.height * 0.4,
      ),
    );
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == QuestionList.questions[currentQuestionIndex].answer) {
      setState(() {
        if (currentQuestionIndex < QuestionList.questions.length - 1) {
          currentQuestionIndex++;
          startTimer();
        } else {
          showDialog(
            context: context,
            builder: (ctx) => CustomAlertDialog(
              heading: 'Attempted!',
              title: 'Congratulations, You have attempted all questions',
              onPress: () {
                Navigator.of(ctx).pop();
                Get.off(const HomeGames());
              },
              imagePath: 'assets/images/trophy.png',
              icons: Icons.tour_sharp,
              width: MediaQuery.of(ctx).size.width * 0.5,
              height: MediaQuery.of(ctx).size.height * 0.4,
            ),
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
          heading: 'Incorrect!',
          title: 'That was not the correct answer. Try again.',
          onPress: () {
            Navigator.of(ctx).pop();
            Get.off(const HomeGames());
          },
          imagePath: 'assets/images/wrong.jpg',
          icons: Icons.warning,
          width: MediaQuery.of(ctx).size.width * 0.5,
          height: MediaQuery.of(ctx).size.height * 0.4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topContainerHeight = MediaQuery.of(context).size.height * 0.45;
    final double topContainerWidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('True/False Quiz'),
        leading: const Icon(Icons.book),
        backgroundColor: AppColor.AppBarColor,
        foregroundColor: AppColor.WhiteColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: topContainerHeight,
                  width: topContainerWidth,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Multiplicationadvance.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2, color: AppColor.ContainerColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColor.AppBarColor,
                  border: Border.all(color: AppColor.WhiteColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      QuestionList.questions[currentQuestionIndex].question,
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _animationController.value,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.ContainerColor),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$_start seconds',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.WhiteColor,
                          backgroundColor: AppColor.AppBarColor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColor.WhiteColor),
                          ),
                        ),
                        onPressed: () => checkAnswer('true'),
                        child: const Text(
                          'True',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.WhiteColor,
                          backgroundColor: AppColor.AppBarColor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColor.WhiteColor),
                          ),
                        ),
                        onPressed: () => checkAnswer('false'),
                        child: const Text(
                          'False',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
