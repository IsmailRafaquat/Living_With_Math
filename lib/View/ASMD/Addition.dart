import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
import 'package:quiz_brain/View/homegames.dart';
import 'package:quiz_brain/colors/colors.dart';
import 'package:quiz_brain/components/dialoguebox.dart';
import 'package:quiz_brain/list/list.dart';

class AdditionAdvance extends StatefulWidget {
  const AdditionAdvance({Key? key}) : super(key: key);

  @override
  State<AdditionAdvance> createState() => _AdditionAdvanceState();
}

class _AdditionAdvanceState extends State<AdditionAdvance>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  late AnimationController _controller;
  late RxInt _start;
  late Timer? _timer; // Declare _timer as a Timer?

  @override
  void initState() {
    super.initState();
    AdditionQuestionList.questions.shuffle(Random());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    _start = 15.obs; // Initialize as RxInt
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

  void checkAnswer(String selectedAnswer) {
    _timer?.cancel(); // Cancel the timer when an answer is selected

    bool correct = selectedAnswer ==
        AdditionQuestionList.questions[currentQuestionIndex].answer;

    if (correct) {
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

  void moveToNextQuestion() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        if (currentQuestionIndex < AdditionQuestionList.questions.length - 1) {
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
                Get.off(() => const HomeGames());
              },
              imagePath: 'assets/images/trophy.png',
              icons: Icons.tour_sharp,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final double topContainerHeight = MediaQuery.of(context).size.height * 0.42;
    final double topContainerWidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Multiplication'),
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
                      AdditionQuestionList.questions[currentQuestionIndex].question,
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
              ..._buildOptions(AdditionQuestionList.questions[currentQuestionIndex].options),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(List<String> options) {
    List<Widget> optionWidgets = [];
    for (int i = 0; i < options.length; i += 2) {
      optionWidgets.add(
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
                  onPressed: () => checkAnswer(options[i]),
                  child: Text(
                    options[i],
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
            if (i + 1 < options.length)
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
                    onPressed: () => checkAnswer(options[i + 1]),
                    child: Text(
                      options[i + 1],
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    return optionWidgets;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure _timer is properly canceled
    _controller.dispose();
    super.dispose();
  }
}
