import 'package:flutter/material.dart';
import 'package:quiz_brain/colors/colors.dart';

class TableAdvance extends StatelessWidget {
  const TableAdvance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Tables'),
        leading: const Icon(Icons.book),
        backgroundColor: AppColor.AppBarColor,
        foregroundColor: AppColor.WhiteColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(20, (index) {
              int tableNumber = index + 1;
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
                        child: TableCard(tableNumber: tableNumber),
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

class TableCard extends StatelessWidget {
  final int tableNumber;
  const TableCard({required this.tableNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Table of $tableNumber',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.WhiteColor
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(10, (index) {
            int multiplier = index + 1;
            int result = tableNumber * multiplier;
            return Text(
              '$tableNumber x $multiplier = $result',
              style: const TextStyle(fontSize: 16,
              color:AppColor.WhiteColor ),
              
            );
          }),
        ),
      ],
    );
  }
}
