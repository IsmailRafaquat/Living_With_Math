import 'package:flutter/material.dart';
import 'package:quiz_brain/colors/colors.dart';

class SquaresAdvance extends StatelessWidget {
  const SquaresAdvance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Squares from 0 to 100'),
        leading: const Icon(Icons.calculate),
        backgroundColor: AppColor.AppBarColor,
        foregroundColor: AppColor.WhiteColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(101, (index) {
              int number = index;
              int square = number * number;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      color: AppColor.AppBarColor,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$number² = $square',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColor.WhiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
