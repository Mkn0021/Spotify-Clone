// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

class GreetingsManager {
  static String getGreetings() {
    final DateTime now = DateTime.now();
    final int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 24) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  static Text getGreetingsText() {
    return Text(
      getGreetings(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontFamily: 'Raleway',
        fontStyle: FontStyle.normal,
        fontSize: 23.0,
      ),
      textAlign: TextAlign.left,
    );
  }
}
