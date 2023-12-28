import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';


mixin AlertMixin {

  Future<void> showErrorDialog(BuildContext context, ErrorType type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Constants.salmon,
          title: Text(
            'エラー発生',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Constants.white
            ),
          ),
          content: SizedBox(
            width: 150,
            height: 100,
            child: Center(
              child: Text(
                Constants.errorDescription(type),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Constants.white
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text(
                '了解',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeletionConfirmationDialog(
    BuildContext context,
    void Function() onConfirm,
    void Function() onCancel
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Constants.salmon,
          title: Text(
            '削除しますか？',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Constants.white
            ),
          ),
          content: SizedBox(
            width: 100,
            height: 80,
            child: Center(
              child: Text(
                '復元は不可能になります。',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Constants.white
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text(
                'キャンセル',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                onCancel();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              child: Text(
                '削除する',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




}