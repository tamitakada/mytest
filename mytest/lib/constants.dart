import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum TestMode {
  lives,
  full,
  practice
}

enum ErrorType {
  fetch,
  save,
  emptyInput
}

enum ConfirmationType {
  unsavedEdits,
  deletion,
  custom
}

class Constants {

  static const uuid = Uuid();

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
      case ErrorType.emptyInput:
        return '問題・解答のどちらかが欠けているカードがあるため、テストは保存できません。';
    }
  }

  static String? confirmationTitle(ConfirmationType type) {
    switch (type) {
      case ConfirmationType.unsavedEdits:
        return '未保存の編集があります';
      case ConfirmationType.deletion:
        return '削除しますか？';
      case ConfirmationType.custom:
        return null;
    }
  }

  static String? confirmationDescription(ConfirmationType type) {
    switch (type) {
      case ConfirmationType.unsavedEdits:
        return '編集を保存せずに続きますか？';
      case ConfirmationType.deletion:
        return '復元は不可能になります。';
      case ConfirmationType.custom:
        return null;
    }
  }

  static String? confirmationConfirmation(ConfirmationType type) {
    switch (type) {
      case ConfirmationType.unsavedEdits:
        return '続く';
      case ConfirmationType.deletion:
        return '削除する';
      case ConfirmationType.custom:
        return null;
    }
  }

}