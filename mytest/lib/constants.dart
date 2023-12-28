import 'package:flutter/material.dart';

enum TestMode {
  lives,
  full,
  practice
}

enum ErrorType {
  fetch,
  save
}

class Constants {

  static const salmon = Color.fromRGBO(239, 98, 108, 1);
  static const sakura = Color.fromRGBO(246, 232, 234, 1);
  static const white = Color.fromRGBO(255, 250, 251, 1);
  static const charcoal = Color.fromRGBO(49, 47, 47, 1);

  static String modeRouteName(TestMode mode) {
    switch (mode) {
      case TestMode.lives:
        return 'lives';
      case TestMode.full:
        return 'full';
      case TestMode.practice:
        return 'practice';
    }
  }

  static String modeName(TestMode mode) {
    switch (mode) {
      case TestMode.lives:
        return '３アウト';
      case TestMode.full:
        return '全問テスト';
      case TestMode.practice:
        return '無限練習';
    }
  }

  static String errorDescription(ErrorType type) {
    switch (type) {
      case ErrorType.fetch:
        return 'データ取得に失敗しました。';
      case ErrorType.save:
        return 'データ保存に失敗しました。ストレージの空き容量をご確認の上、再試行をお願いいたします。';
    }
  }

}