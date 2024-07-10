import 'package:flutter/material.dart';
import 'package:quiz_brain/colors/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    this.buttonColor = AppColor.ContainerColor,
    this.textColor = AppColor.WhiteColor,
    required this.title,
    required this.heading,
    required this.onPress,
    required this.imagePath,
    required this.icons,
    this.width = 280,
    this.height = 280,
    this.loading = false,
    super.key,
  });

  final String heading;
  final String title;
  final double height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor;
  final bool loading;
  final String imagePath;
  final IconData icons;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.AppBarColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            icons,
            color: Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.WhiteColor),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onPress,
          child: Text(
            'OK',
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
