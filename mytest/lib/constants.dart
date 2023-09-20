import 'package:flutter/material.dart';

enum TestMode {
  lives,
  infinite,
  timed
}

class Constants {

  static const darkBlue = Color.fromRGBO(27, 120, 150, 1);
  static const blue = Color.fromRGBO(43, 174, 216, 1);
  static const lightBlue = Color.fromRGBO(73, 194, 233, 1);
  static const yellow = Color.fromRGBO(237, 202, 17, 1);
  static const red = Color.fromRGBO(185, 85, 29, 1);
  static const lightRed = Color.fromRGBO(225, 99, 28, 1);
  static const green = Color.fromRGBO(49, 193, 64, 1);
  static const lightGreen = Color.fromRGBO(59, 219, 75, 1);

  static String modeRouteName(TestMode mode) {
    switch (mode) {
      case TestMode.lives:
        return 'lives';
      case TestMode.infinite:
        return 'infinite';
      case TestMode.timed:
        return 'timed';
    }
  }

  static String modeName(TestMode mode) {
    switch (mode) {
      case TestMode.lives:
        return '３アウト';
      case TestMode.infinite:
        return '力試し';
      case TestMode.timed:
        return 'タイムアタック';
    }
  }

}