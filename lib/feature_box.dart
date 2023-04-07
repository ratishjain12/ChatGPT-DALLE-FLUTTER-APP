// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatgpt_dalle/pallete.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({
    Key? key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
          left: 15.0,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Cera Pro',
                  fontWeight: FontWeight.bold,
                  color: Pallete.blackColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                descriptionText,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 14,
                  color: Pallete.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
