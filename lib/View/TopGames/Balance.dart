import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:quiz_brain/View/homegames.dart';
import 'package:quiz_brain/colors/colors.dart';
import 'package:quiz_brain/components/dialoguebox.dart';
import 'package:quiz_brain/list/list.dart';

class BalanceAdvance extends StatefulWidget {
  const BalanceAdvance({Key? key}) : super(key: key);

  @override
  _BalanceAdvanceState createState() => _BalanceAdvanceState();
}

class _BalanceAdvanceState extends State<BalanceAdvance>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  Timer? _timer;
  late AnimationController _controller;
  RxInt _start = 10.obs; 

  @override
  void initState() {
    super.initState();
    BalanceQuestionList.questions.shuffle();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _start.value = 10; 
    _controller.reset();
    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start.value == 0) {
        timer.cancel();
        showTimeOutDialog();
      } else {
        _start.value--;
      }
    });
  }

  void showTimeOutDialog() {
    Get.dialog(
      CustomAlertDialog(
        heading: 'Time Out!',
        title: 'You did not answer in time. Try again.',
        onPress: () {
          Get.back();
          Get.to(const HomeGames());
        },
        imagePath: 'assets/images/wrong.jpg',
        icons: Icons.warning,
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
      ),
    );
  }

  void checkAnswer(bool selectedAnswer) {
    _timer?.cancel();
    bool correctAnswer =
        BalanceQuestionList.questions[currentQuestionIndex].correctAnswer;
    if (selectedAnswer == correctAnswer) {
      goToNextQuestion();
    } else {
      Get.dialog(
        CustomAlertDialog(
          heading: 'Incorrect!',
          title: 'That was not the correct answer. Try again.',
          onPress: () {
            Get.back();
            Get.to(const HomeGames());
          },
          imagePath: 'assets/images/wrong.jpg',
          icons: Icons.warning,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      );
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < BalanceQuestionList.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        startTimer();
      });
    } else {
      Get.dialog(
        CustomAlertDialog(
          heading: 'Attempted!',
          title: 'Congratulations, You have attempted all questions',
          onPress: () {
            Get.back();
            Get.offAll(const HomeGames());
          },
          imagePath: 'assets/images/trophy.png',
          icons: Icons.tour_sharp,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build');
    final double topContainerHeight =
        MediaQuery.of(context).size.height * 0.42;
    final double topContainerWidth =
        MediaQuery.of(context).size.width * 1;

    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Balancing'),
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
                      BalanceQuestionList.questions[currentQuestionIndex].question,
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
                                    width: MediaQuery.of(context).size.width *
                                        _controller.value,
                                    decoration: BoxDecoration(
                                      color: AppColor.ContainerColor,
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
                              '${_start.value}',
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
              ElevatedButton(
                onPressed: () => checkAnswer(true),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Equal',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => checkAnswer(false),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Not Equal',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
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
