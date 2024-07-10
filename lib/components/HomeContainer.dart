import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_brain/colors/colors.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    this.buttoncolor = AppColor.ContainerColor,
    this.textcolor = AppColor.WhiteColor,
    required this.title,
    required this.onpress,
    required this.svgPath,
    this.width = 60,
    this.height = 60,
    this.loading = false,
    super.key,
  });

  final String title;
  final double height, width;
  final VoidCallback onpress;
  final Color textcolor, buttoncolor;
  final bool loading;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttoncolor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    svgPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0,top: 2),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textcolor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
