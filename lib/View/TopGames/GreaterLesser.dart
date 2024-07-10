import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_brain/View/homegames.dart';
import 'package:quiz_brain/colors/colors.dart';
import 'package:quiz_brain/components/dialoguebox.dart';
import 'package:quiz_brain/list/list.dart';

class GreaterLesserScreen extends StatefulWidget {
  @override
  _GreaterLesserScreenState createState() => _GreaterLesserScreenState();
}

class _GreaterLesserScreenState extends State<GreaterLesserScreen>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  late AnimationController _controller;
  late RxInt _start;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    GreaterLesserQuestionList.questions.shuffle(Random());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    _start = 15.obs;
    startTimer();
  }

  void startTimer() {
    _controller.reset();
    _controller.forward();
    _start.value = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start.value == 0) {
        timer.cancel();
        showTimeOutDialog();
      } else {
        _start.value--;
      }
    });
  }

  void checkAnswer(bool userAnswer) {
    _timer?.cancel();

    bool correctAnswer = GreaterLesserQuestionList.questions[currentQuestionIndex].correctAnswer;
    if (userAnswer == correctAnswer) {
      moveToNextQuestion();
    } else {
      showIncorrectDialog();
    }
  }

 void showIncorrectDialog() {
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
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
      ),
    );
  }
  void showTimeOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => CustomAlertDialog(
        heading: 'Time Out!',
        title: 'You did not answer in time. Try again.',
        onPress: () {
          Navigator.of(ctx).pop();
          Get.off(() => const HomeGames());
        },
        imagePath: 'assets/images/wrong.jpg',
        icons: Icons.warning,
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
      ),
    );
  }

  void moveToNextQuestion() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentQuestionIndex < GreaterLesserQuestionList.questions.length - 1) {
          currentQuestionIndex++;
          startTimer();
        } else {
          showCompletionDialog();
        }
      });
    });
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have completed all questions.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Get.off(() => const HomeGames());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = GreaterLesserQuestionList.questions[currentQuestionIndex];
    final double topContainerHeight = MediaQuery.of(context).size.height * 0.42;
    final double topContainerWidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Greater>|<Lesser'),
        leading: const Icon(Icons.book),
        backgroundColor: AppColor.AppBarColor,
        foregroundColor: AppColor.WhiteColor,
      ),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    border: Border.all(width: 2, color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColor.AppBarColor,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      question.question,
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
                          child: Stack(
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Container(
                                    height: 20,
                                    width: MediaQuery.of(context).size.width * _controller.value,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(() => Text(
                          '$_start',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
          Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => checkAnswer(true),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: Colors.greenAccent,
                    ),
                    child: const Text(
                      'True',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'False',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
    _controller.dispose();
    super.dispose();
  }
}