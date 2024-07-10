import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
import 'package:quiz_brain/View/homegames.dart';
import 'package:quiz_brain/colors/colors.dart';
import 'package:quiz_brain/components/dialoguebox.dart';
import 'package:quiz_brain/list/list.dart';

class HardMath extends StatefulWidget {
  const HardMath({super.key});

  @override
  State<HardMath> createState() => _HardMathState();
}

class _HardMathState extends State<HardMath> with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  Timer? _timer;
  int _start = 10;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    HardQuestionList.questions.shuffle(Random());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      _start = 10;
      _controller.reset();
      _controller.forward();
    });
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
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
      ),
    );
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == HardQuestionList.questions[currentQuestionIndex].answer) {
      setState(() {
        if (currentQuestionIndex < HardQuestionList.questions.length - 1) {
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
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.4,
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
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build');
    final double topContainerHeight = MediaQuery.of(context).size.height * 0.42;
    final double topContainerWidth = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Hard Math'),
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
                      HardQuestionList.questions[currentQuestionIndex].question,
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
                        Text(
                          '$_start',
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
              ..._buildOptions(HardQuestionList.questions[currentQuestionIndex].options),
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
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
