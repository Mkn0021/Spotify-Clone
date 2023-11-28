//This Project is inspired from  (https://github.com/Sangwan5688/BlackHole) 

import 'package:flutter/material.dart';

Widget emptyScreen(
  BuildContext context,
  int turns,
  String text1,
  double size1,
  String text2,
  double size2,
  String text3,
  double size3, {
  bool useBnW = true,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: turns,
            child: Text(
              text1,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: size1,
                color: useBnW
                    ? const Color(0XFFC7C7C7)
                    : Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                text2,
                style: TextStyle(
                  fontSize: size2,
                  color: useBnW
                      ? const Color(0XFF979797)
                      : Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                text3,
                style: TextStyle(
                  fontSize: size3,
                  fontWeight: FontWeight.w600,
                  color: useBnW ? Colors.white : null,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
